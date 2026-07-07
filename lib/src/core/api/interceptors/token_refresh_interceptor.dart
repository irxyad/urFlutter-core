import 'package:dio/dio.dart';
import 'package:urflutter_core/src/shared/shared.dart';

class TokenRefreshInterceptor extends Interceptor {
  final Future<String?> Function() onRefreshToken;
  final Future<void> Function() onRefreshFailed;
  final String refreshPath;

  /// Path lain yang TIDAK boleh ikut antri/diproses oleh mekanisme
  /// refresh ini, walaupun responnya 401.
  ///
  /// Contoh paling penting: endpoint LOGOUT. Kalau logout call kena 401
  /// (karena token sudah invalid), request ini harus langsung gagal
  /// (next ke error handler biasa), BUKAN masuk antrian refresh.
  final List<String> excludePaths;

  final String? tokenPrefix;
  final Dio _dio;

  TokenRefreshInterceptor({
    required Dio dio,
    required this.onRefreshToken,
    required this.onRefreshFailed,
    this.refreshPath = '/auth/refresh',
    this.excludePaths = const [],
    this.tokenPrefix,
  }) : _dio = dio;

  // Kalau sedang refresh, semua request yang 401 akan ditaruh di sini
  // dan di-complete setelah token baru didapat
  final List<_PendingRequest> _queue = [];
  bool _isRefreshing = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    // Bukan 401 maka  biarkan error handler berikutnya yang handle
    if (statusCode != 401) {
      return handler.next(err);
    }
    if (path == refreshPath ||
        excludePaths.contains(path) ||
        err.requestOptions.extra['_isRetry'] == true) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      return _enqueue(err, handler);
    }

    _isRefreshing = true;

    var refreshFailed = false;

    try {
      final newToken = await onRefreshToken();

      if (newToken == null) {
        _failAll(err);
        refreshFailed = true;
        handler.next(err);
        return;
      }

      // Retry semua request yang antri dengan token baru
      await _retryAll(newToken);

      // Retry request yang memicu refresh ini
      handler.resolve(await _retry(err.requestOptions, newToken));
    } catch (e) {
      _failAll(err);
      refreshFailed = true;
      handler.next(err);
    } finally {
      // PENTING: reset _isRefreshing SEBELUM memanggil onRefreshFailed().
      // onRefreshFailed() biasanya memicu side-effect lain (logout, hit
      // endpoint /auth/logout, dll) yang bisa saja menghasilkan request
      // HTTP baru lewat Dio yang sama. Kalau _isRefreshing masih true
      // saat itu terjadi, request tersebut akan masuk _enqueue() dan
      // tidak akan pernah di-resolve -> deadlock.
      _isRefreshing = false;

      // Dipanggil di dalam finally (bukan setelah try-finally) supaya
      // tetap terpanggil walaupun ada `return` di salah satu branch di atas.
      if (refreshFailed) {
        await onRefreshFailed();
      }
    }
  }

  /// Masukkan request ke antrian, akan di-resolve/reject nanti
  void _enqueue(DioException err, ErrorInterceptorHandler handler) {
    _queue.add(_PendingRequest(err.requestOptions, handler));
  }

  /// Retry semua request di antrian dengan [newToken]
  Future<void> _retryAll(String newToken) async {
    final pending = List<_PendingRequest>.from(_queue);
    _queue.clear();

    await Future.wait(
      pending.map((req) async {
        try {
          req.handler.resolve(await _retry(req.options, newToken));
        } catch (e) {
          req.handler.next(DioException(requestOptions: req.options, error: e));
        }
      }),
    );
  }

  /// Reject semua request di antrian.
  ///
  /// PENTING: jangan await [onRefreshFailed] di sini -> sudah dipindah
  /// ke pemanggil ([onError]) SETELAH _isRefreshing direset, supaya
  /// kalau onRefreshFailed() memicu request baru (misal logout) yang
  /// kena 401 lagi, request itu tidak ikut tersangkut _isRefreshing
  /// yang masih true.
  void _failAll(DioException err) {
    final pending = List<_PendingRequest>.from(_queue);
    _queue.clear();

    for (final req in pending) {
      req.handler.next(DioException(requestOptions: req.options, error: err));
    }
  }

  /// Retry satu request dengan token baru.
  /// Extra `_isRetry: true` sebagai guard supaya tidak di-intercept lagi.
  Future<Response<dynamic>> _retry(RequestOptions options, String newToken) {
    return _dio.fetch(
      options.copyWith(
        headers: {
          ...options.headers,
          'Authorization':
              '${tokenPrefix ?? AppConstants.dTokenPrefix} $newToken',
        },
        extra: {...options.extra, '_isRetry': true},
      ),
    );
  }
}

/// Data class untuk request yang sedang antri menunggu token baru
class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  const _PendingRequest(this.options, this.handler);
}
