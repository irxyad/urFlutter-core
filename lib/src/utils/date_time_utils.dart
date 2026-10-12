enum DateDurationUnit { year, month, day }

class DateDuration {
  const DateDuration({required this.value, required this.unit});

  final int value;
  final DateDurationUnit unit;
}

class DateTimeUtils {
  DateTimeUtils._();

  /// Menghitung jumlah bulan penuh antara tanggal mulai dan tanggal akhir.
  ///
  /// Jika tanggal akhir belum mencapai tanggal yang sama dengan tanggal mulai,
  /// jumlah bulan akan dikurangi 1.
  ///
  /// Pengecualian berlaku jika kedua tanggal merupakan hari terakhir bulan.
  static int calculateFullMonthsBetween(DateTime start, DateTime end) {
    int months = (end.year - start.year) * 12 + (end.month - start.month);

    final isStartLastDay =
        start.day == DateTime(start.year, start.month + 1, 0).day;

    final isEndLastDay = end.day == DateTime(end.year, end.month + 1, 0).day;

    if (end.day < start.day && !(isStartLastDay && isEndLastDay)) {
      months -= 1;
    }

    return months;
  }

  /// Menambahkan sejumlah bulan ke tanggal yang diberikan.
  ///
  /// Jika tanggal tidak tersedia pada bulan tujuan, akan menggunakan
  /// hari terakhir dari bulan tersebut.
  static DateTime addMonthsToDate(DateTime date, int months) {
    final year = date.year + ((date.month - 1 + months) ~/ 12);

    final month = (date.month - 1 + months) % 12 + 1;

    final lastDayOfMonth = DateTime(year, month + 1, 0).day;

    if (date.day > lastDayOfMonth) {
      return DateTime(year, month + 1, 1);
    }

    return DateTime(year, month, date.day);
  }

  /// Menghitung durasi antara dua tanggal dalam unit terbesar yang sesuai.
  ///
  /// Contoh:
  /// 2026-01-15 → 2026-03-15 = 2 bulan
  /// 2026-01-15 → 2026-01-20 = 5 hari
  /// 2026-01-01 → 2027-01-01 = 1 tahun
  static DateDuration calculateDuration(DateTime start, DateTime end) {
    if (end.isBefore(start)) {
      return const DateDuration(value: 0, unit: DateDurationUnit.day);
    }

    final months = calculateFullMonthsBetween(start, end);

    // Hitung tanggal setelah full months
    final fullMonthsDate = DateTime(
      start.year,
      start.month + months,
      start.day,
    );

    // Masih ada sisa hari jd dibulatkan menjadi 1 bulan berikutnya
    final hasRemainingDays = end.isAfter(fullMonthsDate);

    final totalMonths = months + (hasRemainingDays ? 1 : 0);

    if (totalMonths >= 12 && totalMonths % 12 == 0) {
      return DateDuration(
        value: totalMonths ~/ 12,
        unit: DateDurationUnit.year,
      );
    }

    if (totalMonths > 0) {
      return DateDuration(value: totalMonths, unit: DateDurationUnit.month);
    }

    return DateDuration(
      value: end.difference(start).inDays,
      unit: DateDurationUnit.day,
    );
  }

  //
  static int calculateTotalMonths(DateTime start, DateTime end) {
    if (end.isBefore(start)) {
      return 0;
    }

    final months = calculateFullMonthsBetween(start, end);

    final fullMonthsDate = DateTime(
      start.year,
      start.month + months,
      start.day,
    );

    // kalau lewat min 1 hari maka bakal dibulatkan sj jadi 1 bulan
    final hasRemainingDays = end.isAfter(fullMonthsDate);

    return months + (hasRemainingDays ? 1 : 0);
  }
}
