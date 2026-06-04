import 'package:flutter/material.dart';

import '../../app_notify.dart';

/// Jika ingin mengubah beberapa konfigurasi default dari [AppNotify],
/// bisa menggunakan [AppNotifyWrapperConfig] yang di init sebelum runApp
///
/// ```dart
/// AppNotifyWrapperConfig(
///   defaultTitles: {
///     NotificationType.error: 'Kesalahan',
///     NotificationType.success: 'Berhasil',
///     NotificationType.info: 'Informasi',
///     NotificationType.warning: 'Peringatan',
///   },
///   defaultPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
///   defaultBorderRadius: BorderRadius.circular(16),
///   defaultIconSize: 20,
/// )
/// ```
class AppNotifyWrapperConfig {
  final ToastificationConfig? config;

  /// Default title.
  ///
  /// Kalau tidak di override, maka akan make default ini:
  /// * Error: 'Error'
  /// * Success: 'Success'
  /// * Info: 'Info'
  /// * Warning: 'Warning'
  final Map<NotificationType, String>? defaultTitles;
  final EdgeInsets? defaultPadding;
  final BorderRadius? defaultBorderRadius;
  final double? defaultIconSize;
  final Map<NotificationType, Color>? customBackgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const AppNotifyWrapperConfig({
    this.config,
    this.defaultTitles,
    this.defaultPadding,
    this.defaultBorderRadius,
    this.defaultIconSize,
    this.customBackgroundColor,
    this.titleStyle,
    this.messageStyle,
  }) : assert(
         defaultIconSize == null || defaultIconSize > 0,
         'defaultIconSize must be positive',
       );

  AppNotifyWrapperConfig copyWith({
    ToastificationConfig? config,
    Map<NotificationType, String>? defaultTitles,
    EdgeInsets? defaultPadding,
    BorderRadius? defaultBorderRadius,
    double? defaultIconSize,
  }) {
    return AppNotifyWrapperConfig(
      config: config ?? this.config,
      defaultTitles: defaultTitles ?? this.defaultTitles,
      defaultPadding: defaultPadding ?? this.defaultPadding,
      defaultBorderRadius: defaultBorderRadius ?? this.defaultBorderRadius,
      defaultIconSize: defaultIconSize ?? this.defaultIconSize,
    );
  }
}
