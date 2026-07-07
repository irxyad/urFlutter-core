import 'package:dio/dio.dart';
import 'package:urflutter_core/src/logging/logging.dart';

class LoggingInterceptor extends Interceptor {
  final String? loggerName;
  final bool logRequest;
  final bool logResponse;
  final bool logError;
  final List<String> excludePaths = [];

  LoggingInterceptor({
    this.loggerName,
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      AppLogger.dioReq(options, loggerName);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse) {
      if (!excludePaths.contains(response.requestOptions.path)) {
        AppLogger.dioRes(response, loggerName);
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      AppLogger.dioError(err, loggerName);
    }
    handler.next(err);
  }
}
