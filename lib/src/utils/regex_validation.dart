class RegexValidation {
  /// Memvalidasi NIK yang terdiri dari tepat 16 digit.
  static bool isValidNIK(String value) => RegExp(r'^\d{16}$').hasMatch(value);

  /// Memvalidasi angka.
  static bool isValidNumber(String value) => RegExp(r'^\d+$').hasMatch(value);

  /// Memvalidasi format email.
  static bool isValidEmail(String value) =>
      RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(value);

  /// Memvalidasi password minimal 8 karakter
  /// dengan minimal satu huruf dan satu angka.
  static bool isValidPassword(String value) =>
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value);

  /// Memvalidasi nama yang hanya berisi huruf dan spasi.
  static bool isValidName(String value) =>
      RegExp(r'^[a-zA-Z ]+$').hasMatch(value);

  /// Memvalidasi alamat yang berisi huruf, angka, koma, dan spasi.
  static bool isValidAddress(String value) =>
      RegExp(r'^[a-zA-Z0-9, ]+$').hasMatch(value);

  /// Memvalidasi nomor telepon dengan format +62.
  static bool isValidPhoneNumber(String value) =>
      RegExp(r'^62\d{10,13}$').hasMatch(value);

  /// Memvalidasi format tanggal YYYY-MM-DD.
  static bool isValidDate(String value) =>
      RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value);

  /// Memvalidasi format waktu HH:mm.
  static bool isValidTime(String value) =>
      RegExp(r'^\d{2}:\d{2}$').hasMatch(value);

  /// Memvalidasi format tanggal dan waktu YYYY-MM-DD HH:mm.
  static bool isValidDateAndTime(String value) =>
      RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$').hasMatch(value);

  /// Memvalidasi rentang tanggal dan waktu.
  static bool isValidDateAndTimeRange(String value) => RegExp(
    r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2} - \d{4}-\d{2}-\d{2} \d{2}:\d{2}$',
  ).hasMatch(value);

  /// Memvalidasi rentang tanggal.
  static bool isValidDateRange(String value) =>
      RegExp(r'^\d{4}-\d{2}-\d{2} - \d{4}-\d{2}-\d{2}$').hasMatch(value);

  /// Memvalidasi rentang waktu.
  static bool isValidTimeRange(String value) =>
      RegExp(r'^\d{2}:\d{2} - \d{2}:\d{2}$').hasMatch(value);

  /// Alias untuk validasi rentang tanggal dan waktu.
  static bool isValidDateTimeRange(String value) => RegExp(
    r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2} - \d{4}-\d{2}-\d{2} \d{2}:\d{2}$',
  ).hasMatch(value);

  /// Memvalidasi format tanggal dan waktu.
  static bool isValidDateTime(String value) =>
      RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$').hasMatch(value);
}
