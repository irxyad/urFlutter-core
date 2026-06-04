import 'dart:math' show pow;

import 'package:flutter/material.dart';

extension ColorX on Color {
  /// Konversi ke hex string uppercase tanpa `#`.
  ///
  /// `Color(0xFFFF5733).toHex()` jadi `"FF5733"`
  /// `Color(0xFFFF5733).toHex(includeAlpha: true)` jadi `"FFFF5733"`
  String toHex({bool includeAlpha = false}) {
    final r = this.r.round().toRadixString(16).padLeft(2, '0');
    final g = this.g.round().toRadixString(16).padLeft(2, '0');
    final b = this.b.round().toRadixString(16).padLeft(2, '0');

    if (!includeAlpha) return '$r$g$b'.toUpperCase();

    final a = this.a.round().toRadixString(16).padLeft(2, '0');
    return '$a$r$g$b'.toUpperCase();
  }

  /// Parse hex string ke [Color]. Mendukung format:
  /// `"FF5733"`, `"#FF5733"`, `"FFFF5733"` (dengan alpha), `"#FFFF5733"`
  ///
  /// Return null kalau format tidak valid.
  static Color? fromHex(String hex) {
    final clean = hex.replaceFirst('#', '').trim();

    if (clean.length == 6) {
      final value = int.tryParse('FF$clean', radix: 16);
      return value != null ? Color(value) : null;
    }

    if (clean.length == 8) {
      final value = int.tryParse(clean, radix: 16);
      return value != null ? Color(value) : null;
    }

    return null;
  }

  /// Konversi ke [MaterialColor] — berguna kalau butuh swatch lengkap
  /// untuk `ThemeData.colorScheme` atau widget yang minta `MaterialColor`.
  MaterialColor toMaterialColor() {
    final swatch = {
      50: lighten(52),
      100: lighten(42),
      200: lighten(30),
      300: lighten(20),
      400: lighten(10),
      500: this,
      600: darken(10),
      700: darken(20),
      800: darken(30),
      900: darken(42),
    };
    return MaterialColor(toInt(), swatch);
  }

  /// Konversi ke int 32-bit ARGB — dipakai [toMaterialColor] dan serialisasi.
  int toInt() =>
      (a.round() << 24) | (r.round() << 16) | (g.round() << 8) | b.round();

  /// Gelap-kan sebesar [percent] (1–100).
  ///
  /// `Colors.blue.darken(20)` jadi  biru 20% lebih gelap
  Color darken([int percent = 10]) {
    assert(percent >= 1 && percent <= 100, 'percent harus antara 1 dan 100');
    final f = 1 - percent / 100;
    return Color.fromARGB(
      a.round(),
      (r * f).round(),
      (g * f).round(),
      (b * f).round(),
    );
  }

  /// Terang-kan sebesar [percent] (1–100).
  ///
  /// `Colors.blue.lighten(20)` jadi  biru 20% lebih terang
  Color lighten([int percent = 10]) {
    assert(percent >= 1 && percent <= 100, 'percent harus antara 1 dan 100');
    final f = percent / 100;
    return Color.fromARGB(
      a.round(),
      (r + (255 - r) * f).round(),
      (g + (255 - g) * f).round(),
      (b + (255 - b) * f).round(),
    );
  }

  /// Atur opacity (0.0–1.0).
  Color withTransparency(double opacity) {
    assert(
      opacity >= 0.0 && opacity <= 1.0,
      'opacity harus antara 0.0 dan 1.0',
    );
    return withValues(alpha: opacity);
  }

  /// Campur warna ini dengan [other] sebesar [t] (0.0 = ini, 1.0 = [other]).
  ///
  /// `Colors.red.mix(Colors.blue, 0.5)` jadi  ungu
  Color mix(Color other, double t) {
    assert(t >= 0.0 && t <= 1.0, 't harus antara 0.0 dan 1.0');
    return Color.fromARGB(
      _lerp(a, other.a, t),
      _lerp(r, other.r, t),
      _lerp(g, other.g, t),
      _lerp(b, other.b, t),
    );
  }

  /// True kalau warna ini tergolong terang (luminance > 0.179).
  bool get isLight => _relativeLuminance > 0.179;

  /// True kalau warna ini tergolong gelap.
  bool get isDark => !isLight;

  /// Kembalikan [Colors.black] atau [Colors.white] — mana yang lebih kontras
  /// terhadap warna ini. Berguna untuk warna teks/ikon di atas background dinamis.
  ///
  /// `myBackgroundColor.contrastColor` jadi  teks yang terbaca
  Color get contrastColor => isLight ? Colors.black : Colors.white;

  /// Contrast ratio WCAG antara warna ini dan [other] (skala 1–21).
  ///
  /// WCAG AA butuh minimal 4.5 untuk teks normal, 3.0 untuk teks besar.
  double contrastRatio(Color other) {
    final la = _relativeLuminance;
    final lb = other._relativeLuminance;
    final lighter = la > lb ? la : lb;
    final darker = la > lb ? lb : la;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// True kalau contrast ratio dengan [other] memenuhi WCAG AA (≥ 4.5).
  bool isAccessibleOn(Color other) => contrastRatio(other) >= 4.5;

  static int _lerp(double a, double b, double t) => (a + (b - a) * t).round();

  /// Relative luminance per WCAG 2.x — https://www.w3.org/TR/WCAG21/#dfn-relative-luminance
  ///
  /// Perbaikan dari versi sebelumnya: linearize pakai pow(s, 2.4) bukan s*s.
  /// s*s itu power 2, bukan 2.4 — hasilnya luminance yang sedikit terlalu tinggi
  /// untuk warna mid-range sehingga contrastRatio bisa meleset.
  double get _relativeLuminance {
    double linearize(double channel) {
      final s = channel / 255;
      return s <= 0.03928
          ? s / 12.92
          : pow((s + 0.055) / 1.055, 2.4).toDouble();
    }

    return 0.2126 * linearize(r) +
        0.7152 * linearize(g) +
        0.0722 * linearize(b);
  }
}

/// Parse hex string ke [Color] langsung dari String.
///
/// `'#FF5733'.toColor()` jadi  `Color(0xFFFF5733)`
/// `'FF5733'.toColor()` jadi  `Color(0xFFFF5733)`
extension HexStringX on String {
  Color? toColor() => ColorX.fromHex(this);
}
