import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'notification_type.dart';

class NotificationConfig {
  final BuildContext? context;
  final String message;
  final NotificationType type;
  final String? title;
  final IconData? icon;
  final Color? backgroundColor;
  final Duration duration;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final void Function(ToastificationItem)? onDismissed;
  final double? iconSize;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const NotificationConfig({
    this.context,
    required this.message,
    required this.type,
    this.backgroundColor,
    this.title,
    this.icon,
    this.duration = const Duration(seconds: 3),
    this.padding,
    this.borderRadius,
    this.onDismissed,
    this.iconSize,
    this.titleStyle,
    this.messageStyle,
  });

  String getTitle(Map<NotificationType, String> defaultTitles) {
    return title ?? defaultTitles[type] ?? type.name.toUpperCase();
  }

  Color getBackgroundColor() => backgroundColor ?? type.defaultColor;

  IconData getIcon() {
    return icon ?? type.defaultIcon;
  }

  NotificationConfig copyWith({
    String? message,
    NotificationType? type,
    String? title,
    IconData? icon,
    Color? backgroundColor,
    Duration? duration,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    void Function(ToastificationItem)? onDismissed,
    double? iconSize,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    return NotificationConfig(
      message: message ?? this.message,
      type: type ?? this.type,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      duration: duration ?? this.duration,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      onDismissed: onDismissed ?? this.onDismissed,
      iconSize: iconSize ?? this.iconSize,
      titleStyle: titleStyle ?? this.titleStyle,
      messageStyle: messageStyle ?? this.messageStyle,
    );
  }
}
