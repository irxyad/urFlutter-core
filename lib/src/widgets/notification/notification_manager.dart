import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'models/notification_config.dart';
import 'models/notification_type.dart';
import 'models/wrapper_config.dart';
import 'notification_card.dart';

typedef NotificationDismissedCallback = void Function(ToastificationItem item);

class AppNotifyWrapper extends StatefulWidget {
  const AppNotifyWrapper({super.key, required this.child, this.config});

  final Widget child;
  final AppNotifyWrapperConfig? config;

  @override
  State<AppNotifyWrapper> createState() => _AppNotifyWrapperState();
}

class _AppNotifyWrapperState extends State<AppNotifyWrapper> {
  @override
  void initState() {
    super.initState();
    AppNotify._initialize(
      defaultTitles: widget.config?.defaultTitles,
      defaultPadding: widget.config?.defaultPadding,
      defaultBorderRadius: widget.config?.defaultBorderRadius,
      defaultIconSize: widget.config?.defaultIconSize,
      customBackgroundColor: widget.config?.customBackgroundColor,
      defaultMessageStyle: widget.config?.messageStyle,
      defaultTitleStyle: widget.config?.titleStyle,
    );
  }

  @override
  Widget build(BuildContext context) => ToastificationWrapper(
    config:
        widget.config?.config ??
        ToastificationConfig(alignment: Alignment.topCenter),
    child: widget.child,
  );
}

/// **PENTING**: [MaterialApp] harus dibungkus dengan ini [AppNotifyWrapper]
///
/// Contoh:
/// ```dart
/// AppNotify.showError('Something went wrong!');
/// AppNotify.showSuccess(
///   'Data saved successfully',
///   duration: Duration(seconds: 5),
/// );
///
/// Kalau mau custom
/// AppNotify.show(NotificationConfig(
///   message: 'Custom message',
///   type: NotificationType.info,
/// ));
/// ```
class AppNotify {
  AppNotify._();

  static final Map<NotificationType, String> _defaultTitlesMap = {
    NotificationType.error: 'Error',
    NotificationType.success: 'Success',
    NotificationType.info: 'Info',
    NotificationType.warning: 'Warning',
  };

  static Map<NotificationType, Color>? _defaultBackgroundColors;
  static Map<NotificationType, String> _defaultTitles = _defaultTitlesMap;

  static const EdgeInsets _defaultPaddingValue = EdgeInsets.all(16);
  static EdgeInsets _defaultPadding = _defaultPaddingValue;
  static final BorderRadius _defaultBorderRadiusValue = BorderRadius.circular(
    12,
  );
  static BorderRadius _defaultBorderRadius = _defaultBorderRadiusValue;
  static const double _defaultIconSizeValue = 16;
  static double _defaultIconSize = _defaultIconSizeValue;

  static TextStyle? _defaultTitleStyle;
  static TextStyle? _defaultMessageStyle;

  static bool _isInitialized = false;

  static void _initialize({
    Map<NotificationType, String>? defaultTitles,
    EdgeInsets? defaultPadding,
    BorderRadius? defaultBorderRadius,
    double? defaultIconSize,
    Map<NotificationType, Color>? customBackgroundColor,
    TextStyle? defaultTitleStyle,
    TextStyle? defaultMessageStyle,
  }) {
    assert(
      defaultIconSize == null || defaultIconSize > 0,
      'Icon size must be positive',
    );
    _defaultTitles = defaultTitles ?? _defaultTitlesMap;
    _defaultPadding = defaultPadding ?? _defaultPaddingValue;
    _defaultBorderRadius = defaultBorderRadius ?? _defaultBorderRadiusValue;
    _defaultIconSize = defaultIconSize ?? _defaultIconSizeValue;
    _defaultBackgroundColors = customBackgroundColor;
    _defaultTitleStyle = defaultTitleStyle;
    _defaultMessageStyle = defaultMessageStyle;
    _isInitialized = true;
  }

  static void _ensureInitialized() {
    assert(
      _isInitialized,
      '\n'
      '═══════════════════════════════════════════════════════════════\n'
      '  AppNotify Error: AppNotifyWrapper not found!\n'
      '═══════════════════════════════════════════════════════════════\n'
      '\n'
      'You must wrap your app with AppNotifyWrapper before using AppNotify.\n'
      '\n'
      'Example:\n'
      '  AppNotifyWrapper(\n'
      '    child: MaterialApp(\n'
      '      home: YourHomePage(),\n'
      '    ),\n'
      '  )\n'
      '\n'
      '═══════════════════════════════════════════════════════════════\n',
    );
  }

  @visibleForTesting
  static void reset() {
    _isInitialized = false;
    _defaultTitles = _defaultTitlesMap;
    _defaultPadding = _defaultPaddingValue;
    _defaultBorderRadius = _defaultBorderRadiusValue;
    _defaultIconSize = _defaultIconSizeValue;
    _defaultBackgroundColors = {};
  }

  static Future<void> _show(NotificationConfig config) async {
    _ensureInitialized();

    assert(config.message.isNotEmpty, 'Notification message cannot be empty');

    try {
      late ToastificationItem toastId;

      toastId = toastification.show(
        context: config.context,
        autoCloseDuration: config.duration,
        animationBuilder: (context, animation, alignment, child) {
          return _DismissibleNotification(
            toastId: toastId,
            config: config,
            defaultPadding: _defaultPadding,
            defaultBorderRadius: _defaultBorderRadius,
            defaultIconSize: _defaultIconSize,
            defaultTitles: _defaultTitles,
            backgroundColor:
                _defaultBackgroundColors?[config.type] ??
                config.getBackgroundColor(),
            messageStyle: _defaultMessageStyle,
            titleStyle: _defaultTitleStyle,
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Failed to show notification: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  /// Error notifikasi
  static Future<void> showError(
    String message, {
    BuildContext? context,
    String? title,
    Duration? duration,
    NotificationDismissedCallback? onDismissed,
  }) {
    return _show(
      NotificationConfig(
        context: context,
        message: message,
        type: NotificationType.error,
        title: title,
        duration: duration ?? const Duration(seconds: 3),
        onDismissed: onDismissed,
      ),
    );
  }

  /// Warning notifikasi
  static Future<void> showWarning(
    String message, {
    BuildContext? context,
    String? title,
    Duration? duration,
    NotificationDismissedCallback? onDismissed,
  }) {
    return _show(
      NotificationConfig(
        context: context,
        message: message,
        type: NotificationType.warning,
        title: title,
        duration: duration ?? const Duration(seconds: 3),
        onDismissed: onDismissed,
      ),
    );
  }

  /// Success notifikasi
  static Future<void> showSuccess(
    String message, {
    BuildContext? context,
    String? title,
    Duration? duration,
    NotificationDismissedCallback? onDismissed,
  }) {
    return _show(
      NotificationConfig(
        context: context,
        message: message,
        type: NotificationType.success,
        title: title,
        duration: duration ?? const Duration(seconds: 3),
        onDismissed: onDismissed,
      ),
    );
  }

  /// Info notifikasi
  static Future<void> showInfo(
    String message, {
    BuildContext? context,
    String? title,
    Duration? duration,
    NotificationDismissedCallback? onDismissed,
  }) {
    return _show(
      NotificationConfig(
        context: context,
        message: message,
        type: NotificationType.info,
        title: title,
        duration: duration ?? const Duration(seconds: 3),
        onDismissed: onDismissed,
      ),
    );
  }

  /// Menutup semua notifikasi yang sedang tampil.
  static void dismissAll() {
    _ensureInitialized();
    toastification.dismissAll();
  }
}

class _DismissibleNotification extends StatefulWidget {
  final ToastificationItem toastId;
  final NotificationConfig config;
  final EdgeInsets defaultPadding;
  final BorderRadius defaultBorderRadius;
  final double defaultIconSize;
  final Map<NotificationType, String> defaultTitles;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const _DismissibleNotification({
    required this.toastId,
    required this.config,
    required this.defaultPadding,
    required this.defaultBorderRadius,
    required this.defaultIconSize,
    required this.defaultTitles,
    required this.backgroundColor,
    this.titleStyle,
    this.messageStyle,
  });

  @override
  State<_DismissibleNotification> createState() =>
      _DismissibleNotificationState();
}

class _DismissibleNotificationState extends State<_DismissibleNotification> {
  final _offsetController = ValueNotifier<double>(0);
  double _dragOffset = 0;

  static const double _dismissThreshold = -200;
  static const double _dismissVelocityThreshold = -500;

  @override
  void dispose() {
    _offsetController.dispose();
    super.dispose();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    _dragOffset += details.delta.dy;
    _offsetController.value = _dragOffset.clamp(_dismissThreshold, 0);
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_shouldDismiss(details.primaryVelocity)) {
      _dismiss();
    } else {
      _reset();
    }
  }

  bool _shouldDismiss(double? velocity) {
    final draggedFarEnough = _offsetController.value <= _dismissThreshold * 0.7;
    final velocityHighEnough =
        velocity != null && velocity < _dismissVelocityThreshold;

    return draggedFarEnough || velocityHighEnough;
  }

  void _dismiss() {
    toastification.dismiss(widget.toastId, showRemoveAnimation: false);
    Future.microtask(() => widget.config.onDismissed?.call(widget.toastId));
  }

  void _reset() {
    _dragOffset = 0;
    _offsetController.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _handleVerticalDragUpdate,
      onVerticalDragEnd: _handleVerticalDragEnd,
      child: ValueListenableBuilder<double>(
        valueListenable: _offsetController,
        builder: (context, offsetY, _) {
          return NotificationCard(
            backgroundColor: widget.backgroundColor,
            icon: widget.config.getIcon(),
            title: widget.config.getTitle(widget.defaultTitles),
            message: widget.config.message,
            onClose: () => toastification.dismiss(widget.toastId),
            offsetY: offsetY,
            padding: widget.config.padding ?? widget.defaultPadding,
            borderRadius:
                widget.config.borderRadius ?? widget.defaultBorderRadius,
            iconSize: widget.config.iconSize ?? widget.defaultIconSize,
            titleStyle: widget.titleStyle,
            messageStyle: widget.messageStyle,
          );
        },
      ),
    );
  }
}
