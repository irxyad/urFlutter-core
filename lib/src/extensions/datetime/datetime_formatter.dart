import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormatter {
  const DateTimeFormatter._();

  /// "2025-07-30"
  static String toIsoDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  /// "30-07-2025_17-00-00"
  static String toFilename(DateTime date) =>
      DateFormat('dd-MM-yyyy_HH-mm-ss').format(date);

  /// Format bebas dengan optional locale.
  /// Contoh: `format(date, 'd MMM yyyy', locale: 'id')` → "30 Jul 2025"
  static String format(
    DateTime date, {
    String pattern = 'd MMM yyyy',
    String? locale,
  }) => DateFormat(pattern, locale).format(date);

  /// Date-range
  ///
  /// | Kondisi                | en                         | id                        |
  /// |------------------------|----------------------------|---------------------------|
  /// | Hari sama              | May 14, 2025               | 14 Mei 2025               |
  /// | Bulan sama             | May 12–14, 2025            | 12–14 Mei 2025            |
  /// | Tahun sama, beda bulan | May 28 – Jun 2, 2025       | 28 Mei – 2 Jun 2025       |
  /// | Beda tahun             | Dec 30, 2024 – Jan 2, 2025 | 30 Des 2024 – 2 Jan 2025  |
  static String formatRange(
    DateTime start,
    DateTime end, {
    String locale = 'en',
  }) {
    final isId = locale == 'id';

    if (start.year == end.year) {
      if (start.month == end.month) {
        if (start.day == end.day) {
          return DateFormat.yMMMd(locale).format(start);
        }
        // Bulan sama, hari beda
        final s = DateFormat.d(locale).format(start);
        final e = DateFormat.d(locale).format(end);
        final month = DateFormat.MMM(locale).format(start);
        final year = DateFormat.y(locale).format(start);
        return isId ? '$s–$e $month $year' : '$month $s–$e, $year';
      }
      // Tahun sama, bulan beda
      final sd = DateFormat.d(locale).format(start);
      final ed = DateFormat.d(locale).format(end);
      final sm = DateFormat.MMM(locale).format(start);
      final em = DateFormat.MMM(locale).format(end);
      final year = DateFormat.y(locale).format(start);
      return isId ? '$sd $sm – $ed $em $year' : '$sm $sd – $em $ed, $year';
    }

    // Beda tahun
    return '${DateFormat.yMMMd(locale).format(start)} – '
        '${DateFormat.yMMMd(locale).format(end)}';
  }

  /// True kalau [date] adalah satu hari kalender sebelum [reference].
  ///
  /// Menggunakan perbandingan kalender (bukan Duration.inDays) supaya
  /// edge case seperti DST atau waktu yang tidak tepat midnight tetap benar.
  static bool isYesterday(DateTime reference, DateTime date) {
    final refDay = DateTime(reference.year, reference.month, reference.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    return refDay.difference(dateDay).inDays == 1;
  }

  /// Total minggu kalender yang overlap dengan [month] di [year].
  /// Berguna untuk membangun grid kalender.
  static int totalWeeksInMonth(int year, int month) {
    final first = DateTime(year, month);
    final last = DateTime(year, month + 1, 0);
    final firstWeek = (first.day + first.weekday - 1) ~/ 7 + 1;
    final lastWeek = (last.day + last.weekday - 1) ~/ 7 + 1;
    return lastWeek - firstWeek + 1;
  }

  /// Parse "HH:mm" atau "HH:mm:ss" ke [TimeOfDay]. Return null kalau gagal.
  static TimeOfDay? parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }
}
