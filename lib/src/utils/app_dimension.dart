import 'package:flutter/material.dart';

/// Tambahkan [AppDimension.configure] sebelum [runApp])
/// jika ingin mengganti nilai defaultnya
///
/// ```dart
/// void main() {
///   AppDimension.configure(spacing: 16, radius: 8);
///   runApp(const MyApp());
/// }
/// ```
class AppDimension {
  const AppDimension._();

  static const double _defaultSpacing = 20;
  static const double _defaultRadius = 11;
  static const double _defaultButtonHeight = 38;

  static double _spacing = _defaultSpacing;
  static double _radius = _defaultRadius;
  static double _buttonHeight = _defaultButtonHeight;

  static void configure({
    double? spacing,
    double? radius,
    double? buttonHeight,
  }) {
    _spacing = spacing ?? _defaultSpacing;
    _radius = radius ?? _defaultRadius;
    _buttonHeight = buttonHeight ?? _defaultButtonHeight;
  }

  static void reset() {
    _spacing = _defaultSpacing;
    _radius = _defaultRadius;
    _buttonHeight = _defaultButtonHeight;
  }

  static double get spacing => _spacing;
  static double get spacingSmall => _spacing / 2;
  static double get radius => _radius;
  static double get radiusSmall => _radius / 2;
  static double get buttonHeight => _buttonHeight;

  static EdgeInsets get padding => EdgeInsets.all(_spacing);
  static EdgeInsets get paddingSmall => EdgeInsets.all(_spacing / 2);
  static EdgeInsets get paddingH => EdgeInsets.symmetric(horizontal: _spacing);
  static EdgeInsets get paddingV => EdgeInsets.symmetric(vertical: _spacing);

  static BorderRadius get borderRadius => BorderRadius.circular(_radius);
  static BorderRadius get borderRadiusSmall =>
      BorderRadius.circular(_radius / 2);

  static Widget get hSpace => SizedBox(width: _spacing);
  static Widget get vSpace => SizedBox(height: _spacing);
  static Widget get hSpaceSmall => SizedBox(width: _spacing / 2);
  static Widget get vSpaceSmall => SizedBox(height: _spacing / 2);
}
