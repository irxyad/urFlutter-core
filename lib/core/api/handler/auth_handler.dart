import '../../logging/logging.dart';

class AuthHandler {
  AuthHandler._();

  static AuthHandler? _instance;
  static AuthHandler get instance => _instance ??= AuthHandler._();

  bool _isHandlingAuth = false;

  Future<void> Function()? onUnauthorized;
  Future<void> Function()? onSignOutComplete;
  void Function(Object error, StackTrace stackTrace)? onError;

  /// Contoh:
  /// ```dart
  /// AuthHandler.instance.initialize(
  ///   onUnauthorized: () async {
  ///     await getIt<AuthCubit>().signOut();
  ///   },
  ///   onSignOutComplete: () async {
  ///     navigatorKey.currentContext?.go('/login');
  ///   },
  ///   onError: (error, stack) {
  ///     AppLogger.e('AuthHandler', error.toString());
  ///   },
  /// );
  /// ```
  void initialize({
    required Future<void> Function() onUnauthorized,
    Future<void> Function()? onSignOutComplete,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    this.onUnauthorized = onUnauthorized;
    this.onSignOutComplete = onSignOutComplete;
    this.onError = onError;
  }

  Future<void> handleUnauthorized() async {
    if (_isHandlingAuth) {
      AppLogger.d('AuthHandler', 'Already handling auth');
      return;
    }

    if (onUnauthorized == null) {
      AppLogger.d('AuthHandler', 'onUnauthorized callback not set');
      return;
    }

    _isHandlingAuth = true;

    try {
      await onUnauthorized!();

      await onSignOutComplete?.call();
    } catch (error, stackTrace) {
      AppLogger.e('AuthHandler', 'Error handling auth: $error');

      onError?.call(error, stackTrace);

      rethrow;
    } finally {
      _isHandlingAuth = false;
    }
  }

  bool get isHandlingAuth => _isHandlingAuth;

  void reset() {
    _isHandlingAuth = false;
  }

  void dispose() {
    onUnauthorized = null;
    onSignOutComplete = null;
    onError = null;
    _isHandlingAuth = false;
  }
}
