import 'package:mason/mason.dart';

extension LoggerX on Logger {
  /// Untuk menampilkan logger dengan prefix [✓]
  void done(String message, {String? hint}) {
    final hintTxt = hint == null ? '' : darkGray.wrap(hint) ?? '';

    write('${lightGreen.wrap('✓ ')}${lightGray.wrap("$message ")}$hintTxt \n');
  }
}
