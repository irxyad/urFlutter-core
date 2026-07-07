import 'package:flutter/material.dart';

import '../types/loading_type.dart';

class LoadingConfig {
  final LoadingType type;
  final String? message;
  final bool showMessage;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? textColor;
  final double? size;
  final LoadingPosition position;
  final bool dismissible;
  final bool blurBackground;

  /// Tampilin loading dalam mode kompak atau minimalis
  final bool isCompact;
  final double blurAmount;
  final double? borderRadius;
  final EdgeInsets? padding;

  /// Buat ganti widget loading
  final Widget? customWidget;
  final Duration? minDuration;
  final Widget? customIndicator;
  final TextStyle? messageStyle;

  const LoadingConfig({
    this.type = LoadingType.newtonCradle,
    this.message,
    this.showMessage = true,
    this.backgroundColor,
    this.indicatorColor,
    this.textColor,
    this.size,
    this.position = LoadingPosition.center,
    this.dismissible = false,
    this.blurBackground = false,
    this.blurAmount = 5.0,
    this.borderRadius,
    this.padding,
    this.customWidget,
    this.minDuration,
    this.customIndicator,
    this.messageStyle,
    this.isCompact = false,
  });

  LoadingConfig copyWith({
    LoadingType? type,
    String? message,
    bool? showMessage,
    Color? backgroundColor,
    Color? indicatorColor,
    Color? textColor,
    double? size,
    LoadingPosition? position,
    bool? dismissible,
    bool? blurBackground,
    bool? isCompact,
    double? blurAmount,
    double? borderRadius,
    EdgeInsets? padding,
    Widget? customWidget,
    Duration? minDuration,
    Widget? customIndicator,
    TextStyle? messageStyle,
  }) {
    return LoadingConfig(
      type: type ?? this.type,
      message: message ?? this.message,
      showMessage: showMessage ?? this.showMessage,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      textColor: textColor ?? this.textColor,
      size: size ?? this.size,
      position: position ?? this.position,
      dismissible: dismissible ?? this.dismissible,
      blurBackground: blurBackground ?? this.blurBackground,
      blurAmount: blurAmount ?? this.blurAmount,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      customWidget: customWidget ?? this.customWidget,
      minDuration: minDuration ?? this.minDuration,
      customIndicator: customIndicator ?? this.customIndicator,
      messageStyle: messageStyle ?? this.messageStyle,
      isCompact: isCompact ?? this.isCompact,
    );
  }
}
