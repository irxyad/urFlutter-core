import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static Color hexColor(String value) =>
      Color(0xFF000000 | int.parse(value, radix: 16));

  Color darken(Color c, [int percent = 10]) {
    assert(
      1 <= percent && percent <= 100,
      'Persen harus diatas 1 dan dibawah 100',
    );

    final f = 1 - percent / 100;
    return Color.fromARGB(
      c.a.round(),
      (c.r * f).round(),
      (c.g * f).round(),
      (c.b * f).round(),
    );
  }
}
