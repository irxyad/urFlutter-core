import 'package:dio/dio.dart';

/// Setup di [NetworkModule]:
/// ```dart
/// NetworkModule.register(
///   config: ApiConfig.prod(baseUrl: Env.apiUrl),
///   tokenProvider: () => storage.getAccessToken(),
///   onRefreshToken: () => authRepo.refreshToken(),  // return token baru / null
///   onRefreshFailed: () => authCubit.logout(),      // dipanggil kalau refresh gagal
/// );
/// ```
class TokenRefreshInterceptor extends Interceptor {
  /// Fungsi untuk melakukan refresh — return access token baru, atau null kalau gagal
  final Future<String?> Function() onRefreshToken;

  /// Dipanggil kalau refresh benar-benar gagal (misal: logout user)
  final Future<void> Function() onRefreshFailed;

  /// Path endpoint refresh token — digunakan sebagai loop guard
  /// Contoh: '/auth/refresh'
  final String refreshPath;

  /// Prefix token di header Authorization
  final String tokenPrefix;

  final Dio _dio;

  TokenRefreshInterceptor({
    required Dio dio,
    required this.onRefreshToken,
    required this.onRefreshFailed,
    this.refreshPath = '/auth/refresh',
    this.tokenPrefix = 'Bearer',
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

    // Loop guard: kalau request refresh sendiri yang 401,
    // langsung gagal tanpa retry supaya tidak infinite loop
    if (path == refreshPath || err.requestOptions.extra['_isRetry'] == true) {
      await _failAll(err);
      return handler.next(err);
    }

    // Kalau sedang refresh, masukkan ke antrian
    if (_isRefreshing) {
      return _enqueue(err, handler);
    }

    // Mulai proses refresh
    _isRefreshing = true;

    try {
      final newToken = await onRefreshToken();

      if (newToken == null) {
        // Refresh berhasil dipanggil tapi tidak dapat token baru
        await _failAll(err);
        return handler.next(err);
      }

      // Retry semua request yang antri dengan token baru
      await _retryAll(newToken);

      // Retry request yang memicu refresh ini
      handler.resolve(await _retry(err.requestOptions, newToken));
    } catch (e) {
      // Refresh throw exception (network error, dll)
      await _failAll(err);
      handler.next(err);
    } finally {
      _isRefreshing = false;
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

  /// Reject semua request di antrian dan panggil [onRefreshFailed]
  Future<void> _failAll(DioException err) async {
    final pending = List<_PendingRequest>.from(_queue);
    _queue.clear();

    for (final req in pending) {
      req.handler.next(DioException(requestOptions: req.options, error: err));
    }

    await onRefreshFailed();
  }

  /// Retry satu request dengan token baru.
  /// Extra `_isRetry: true` sebagai guard supaya tidak di-intercept lagi.
  Future<Response<dynamic>> _retry(RequestOptions options, String newToken) {
    return _dio.fetch(
      options.copyWith(
        headers: {
          ...options.headers,
          'Authorization': '$tokenPrefix $newToken',
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
