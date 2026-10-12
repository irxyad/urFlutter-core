import 'package:flutter/material.dart';

extension StringUtils on String {
  /// Mengubah spasi menjadi underscore dan huruf menjadi lowercase.
  /// Contoh: "Halo Dunia" -> "halo_dunia"
  String get toSnakeCase => trim().replaceAll(' ', '_').toLowerCase();

  /// Menghapus semua spasi.
  /// Contoh: "Halo Dunia" -> "HaloDunia"
  String get removeAllWhitespace => trim().replaceAll(' ', '');

  /// Mengubah spasi menjadi tanda dash.
  /// Contoh: "Halo Dunia" -> "Halo-Dunia"
  String get convertSpaceToDash => trim().replaceAll(' ', '-');

  /// Mengubah huruf pertama menjadi uppercase.
  /// Contoh: "halo dunia" -> "Halo dunia"
  String get firstUppercase => '${this[0].toUpperCase()}${substring(1)}';

  /// Mengecek apakah string hanya terdiri dari satu baris.
  /// Contoh:
  /// ```dart
  /// 'halo dunia'.isSingleLine; // true
  /// 'halo\n dunia'.isSingleLine; // false
  /// ```
  bool get isSingleLine => split('\n').length == 1;

  /// Menghapus dua segmen pertama dari sebuah route.
  /// Contoh: "/a/b" -> "/b"
  String get removeRouteParent {
    final splitted = split('/')..removeRange(0, 2);
    return splitted.join('/');
  }

  /// Mengecek apakah teks melebihi jumlah [maxLines] yang ditentukan.
  ///
  /// Tetap dapat mendeteksi overflow meskipun teks tidak memiliki `\n`.
  bool isTextOverflowing({
    required TextStyle style,
    required double maxWidth,
    int maxLines = 3,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }
}
