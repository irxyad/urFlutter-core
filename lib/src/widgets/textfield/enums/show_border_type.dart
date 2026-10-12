import 'package:flutter/material.dart';
import 'package:urflutter_core/src/styles/colors.dart';
import 'package:urflutter_core/src/urflutter_config.dart';
import 'package:urflutter_core/src/utils/app_dimension.dart';

enum ShowBorderType { always, focus, none }

extension ShowBorderTypeExtension on ShowBorderType {
  InputDecoration getDecoration(BorderRadius? borderRadius) {
    return switch (this) {
      ShowBorderType.always => _always(borderRadius: borderRadius),
      ShowBorderType.focus => _focus(borderRadius: borderRadius),
      ShowBorderType.none => _none(borderRadius: borderRadius),
    };
  }
}

BorderRadius _resolvedRadius(BorderRadius? borderRadius) =>
    borderRadius ?? BorderRadius.circular(UrDimension.radiusSmall);

// Selalu nampil
InputDecoration _always({BorderRadius? borderRadius}) {
  final radius = _resolvedRadius(borderRadius);
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: UrFlutterConfig.appColors.appPrimary,
        width: .5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: UrFlutterConfig.appColors.appPrimary,
        width: .5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: UrFlutterConfig.appColors.appPrimary,
        width: .5,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: UrColors.darkGray, width: .5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Colors.red, width: .5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Colors.red, width: .5),
    ),
  );
}

// Saat Focus saja
InputDecoration _focus({BorderRadius? borderRadius}) {
  final radius = _resolvedRadius(borderRadius);
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: UrFlutterConfig.appColors.appPrimary,
        width: .5,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: UrColors.darkGray, width: .5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Colors.red, width: .5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Colors.red, width: .5),
    ),
  );
}

// Tidak ada border
InputDecoration _none({BorderRadius? borderRadius}) {
  final radius = _resolvedRadius(borderRadius);
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
  );
}
