import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'datetime_formatter.dart';

extension DateTimeX on DateTime {
  /// "2025-07-30"
  String toIsoDate() => DateTimeFormatter.toIsoDate(this);

  /// "30-07-2025_17-00-00"
  String toFilename() => DateTimeFormatter.toFilename(this);

  /// Format bebas dengan optional locale.
  /// Contoh: `dt.format(pattern: 'EEEE, d MMMM yyyy', locale: 'id')`
  String format({String pattern = 'd MMM yyyy', String? locale}) =>
      DateTimeFormatter.format(this, pattern: pattern, locale: locale);

  /// True kalau `this` adalah satu hari kalender sebelum [reference].
  /// Contoh: `yesterday.isYesterdayOf(DateTime.now())` → true
  bool isYesterdayOf(DateTime reference) =>
      DateTimeFormatter.isYesterday(reference, this);

  /// True kalau `this` dan [other] adalah hari kalender yang sama
  bool isSameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// True kalau `this` adalah hari ini
  bool get isToday => isSameDayAs(DateTime.now());

  /// True kalau `this` adalah kemarin
  bool get isYesterday => isYesterdayOf(DateTime.now());

  /// Kembalikan DateTime dengan waktu di-reset ke 00:00:00
  DateTime get startOfDay => DateTime(year, month, day);

  /// Kembalikan DateTime dengan waktu di-set ke 23:59:59
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Total minggu kalender yang overlap dengan bulan ini.
  /// Berguna untuk membangun grid kalender.
  int get totalWeeksInMonth => DateTimeFormatter.totalWeeksInMonth(year, month);
}

extension DateTimeLocalized on DateTime {
  /// "Tuesday, 30 July 2025" / "Selasa, 30 Juli 2025"
  String toFullDate(String locale) =>
      DateFormat.yMMMMEEEEd(locale).format(this);

  /// "30 Jul 2025" — pass [pattern] untuk override format
  String toLocalDate(String locale, {String pattern = 'd MMM yyyy'}) =>
      DateFormat(pattern, locale).format(this);

  /// "17:00" atau "5:00 PM" tergantung locale
  String toLocalTime(String locale) => DateFormat.Hm(locale).format(this);

  /// "Tuesday, 30 July 2025 pukul 17:00"
  /// [timeLabel] bisa diisi dari l10n: `context.tr(LocaleKeys.at)`
  String toFullDateWithTime(String locale, {String timeLabel = 'at'}) =>
      '${toFullDate(locale)} $timeLabel ${toLocalTime(locale)}';

  /// "Tuesday 30 | 17:00"
  String toShortDateWithTime(String locale) =>
      '${DateFormat('EEEE d', locale).format(this)} | ${toLocalTime(locale)}';

  /// Smart range ke [end].
  /// - Hari sama → "30 Jul 2025"
  /// - Bulan sama → "1–15 Jul 2025"
  /// - Tahun sama → "1 Jun – 15 Jul 2025"
  /// - Beda tahun → "1 Jun 2024 – 15 Jul 2025"
  String toLocalRange(DateTime end, String locale) =>
      DateTimeFormatter.formatRange(this, end, locale: locale);
}

/// BuildContext helper — jembatan antara widget tree dan [DateTimeLocalized].
///
/// Tetap dipisah supaya [DateTimeLocalized] tidak terikat ke Flutter widget layer.
extension DateTimeContextShortcut on BuildContext {
  /// Locale code dari context, contoh: "id", "en"
  String get currentLocale => Localizations.localeOf(this).languageCode;
}

/// Parse string waktu ke [TimeOfDay].
///
/// Contoh:
/// ```dart
/// '17:30'.toTimeOfDay()        // TimeOfDay(hour: 17, minute: 30)
/// '17:30:00'.toTimeOfDay()     // TimeOfDay(hour: 17, minute: 30)
/// 'invalid'.toTimeOfDay()      // null
/// ```
extension TimeStringX on String {
  TimeOfDay? toTimeOfDay() => DateTimeFormatter.parseTime(this);
}

/// Helper pada [TimeOfDay] untuk konversi ke format yang umum dipakai.
extension TimeOfDayX on TimeOfDay {
  /// "17:30"
  String toHHmm() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Konversi ke [DateTime] hari ini dengan jam dan menit dari [TimeOfDay] ini
  DateTime toDateTimeToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
