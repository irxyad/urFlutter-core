import 'package:flutter/material.dart';

class UrColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFFCFCFCF);
  static const Color softGray = Color(0xFFF0F3F7);
  static const Color darkGray = Color(0xFF797989);
  static const Color black = Color(0xFF121212);
  static const Color red = Color(0xFFFF1313);
  static const Color softWhite = Color(0xFFEFF6FC);
  static const Color darkRed = Colors.redAccent;
  static const Color background = Color(0xFFf8f8ff);
}

abstract class UrAppColors {
  Color get appPrimary;
}
