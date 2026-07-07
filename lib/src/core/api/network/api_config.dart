class ApiConfig {
  final String baseUrl;

  /// Timeout koneksi ke server (default 15 detik)
  final Duration connectTimeout;

  /// Timeout tunggu response dari server (default 30 detik)
  final Duration receiveTimeout;

  /// Timeout kirim data ke server (default 30 detik)
  final Duration sendTimeout;
  final Map<String, String> defaultHeaders;
  final bool enableLogging;

  /// List endpoint yang tidak akan mengirim token
  /// contoh: /login
  final List<String> excludeTokenPaths;

  /// List endpoint jika token expired atau 401
  /// maka tidak akan di-intercept oleh [TokenRefreshInterceptor]
  /// contoh: /login
  final List<String> excludeRefreshTokenPaths;

  /// Endpoint untuk refresh token.
  final String refreshPath;
  final String? tokenPrefix;

  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders = const {},
    this.enableLogging = false,
    this.excludeTokenPaths = const [],
    this.excludeRefreshTokenPaths = const [],
    this.refreshPath = '/auth/refresh',
    this.tokenPrefix,
  });

  factory ApiConfig.dev({required String baseUrl, String? refreshPath}) =>
      ApiConfig(
        baseUrl: baseUrl,
        enableLogging: true,
        refreshPath: refreshPath ?? '/auth/refresh',
      );

  factory ApiConfig.prod({
    required String baseUrl,
    Map<String, String> defaultHeaders = const {},
    String? refreshPath,
  }) => ApiConfig(
    baseUrl: baseUrl,
    defaultHeaders: defaultHeaders,
    enableLogging: false,
    refreshPath: refreshPath ?? '/auth/refresh',
  );
}
