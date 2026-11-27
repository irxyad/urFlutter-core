import 'package:flutter/material.dart';

class UrRadioOption<T> {
  const UrRadioOption({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
  });

  final T value;
  final String label;
  final IconData? icon;
  final Color? iconColor;
}
