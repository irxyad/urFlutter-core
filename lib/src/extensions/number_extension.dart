import 'package:intl/intl.dart';

/// Memformat angka menjadi mata uang berdasarkan [locale].
///
/// Contoh:
/// ```dart
/// 150000.toCurrency('id_ID'); // Rp150.000
/// ```
extension NumExtension on num {
  String toCurrency([String? locale]) {
    return NumberFormat.simpleCurrency(
      locale: locale ?? 'id_ID',
      decimalDigits: 0,
    ).format(this);
  }
}
