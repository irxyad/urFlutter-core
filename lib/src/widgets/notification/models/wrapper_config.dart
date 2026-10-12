import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../notification.dart';

/// Jika ingin mengubah beberapa konfigurasi default dari [UrNotify],
/// bisa menggunakan [UrNotifyWrapperConfig] yang di init sebelum runApp
///
/// ```dart
/// UrNotifyWrapperConfig(
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
class UrNotifyWrapperConfig {
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

  const UrNotifyWrapperConfig({
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

  UrNotifyWrapperConfig copyWith({
    ToastificationConfig? config,
    Map<NotificationType, String>? defaultTitles,
    EdgeInsets? defaultPadding,
    BorderRadius? defaultBorderRadius,
    double? defaultIconSize,
  }) {
    return UrNotifyWrapperConfig(
      config: config ?? this.config,
      defaultTitles: defaultTitles ?? this.defaultTitles,
      defaultPadding: defaultPadding ?? this.defaultPadding,
      defaultBorderRadius: defaultBorderRadius ?? this.defaultBorderRadius,
      defaultIconSize: defaultIconSize ?? this.defaultIconSize,
    );
  }
}
