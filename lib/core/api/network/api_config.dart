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

  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders = const {},
    this.enableLogging = false,
  });

  factory ApiConfig.dev({required String baseUrl}) =>
      ApiConfig(baseUrl: baseUrl, enableLogging: true);

  factory ApiConfig.prod({
    required String baseUrl,
    Map<String, String> defaultHeaders = const {},
  }) => ApiConfig(
    baseUrl: baseUrl,
    defaultHeaders: defaultHeaders,
    enableLogging: false,
  );
}
