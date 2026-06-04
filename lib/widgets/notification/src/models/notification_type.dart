import 'package:flutter/material.dart';

enum NotificationType {
  error,
  warning,
  success,
  info;

  Color get defaultColor {
    switch (this) {
      case NotificationType.error:
        return Colors.redAccent;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.info:
        return Colors.blueAccent;
    }
  }

  IconData get defaultIcon {
    switch (this) {
      case NotificationType.error:
        return Icons.cancel;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.info:
        return Icons.info;
    }
  }
}