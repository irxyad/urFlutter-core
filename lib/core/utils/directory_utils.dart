import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../extensions/datetime/datetime_formatter.dart';
import '../logging/src/app_logger.dart';

class DirectoryUtils {
  const DirectoryUtils._();

  /// Download gambar dari [imageUrl] simpan ke temp
  ///
  /// Kalau ada file dengan nama sama, akan dihapus dulu
  /// Exception kalau gagal download atau bukan 200
  static Future<File> downloadAndSaveImage(
    String imageUrl,
    String fileName,
  ) async {
    final dir = await getTemporaryDirectory();
    final filePath = p.join(dir.path, fileName);
    final file = File(filePath);

    if (file.existsSync()) {
      await file.delete();
      AppLogger.i('Deleted existing file: $filePath');
    }

    AppLogger.i('Downloading image to: $filePath');

    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      return file;
    }

    final reason = response.statusCode == 404 ? 'not found' : 'download failed';
    AppLogger.e('Image $reason [$imageUrl] — status ${response.statusCode}');
    throw Exception('Image $reason (${response.statusCode})');
  }

  static Future<File> writeToTemp(Uint8List data, String filename) async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, filename));

    if (file.existsSync()) await file.delete();

    return file.writeAsBytes(data);
  }

  /// Return kata terakhir di [filename] yang dipisahkan oleh underscore, atau null.
  ///
  /// e.g. `"abc_image.jpg"` to `"image.jpg"`
  static String? extractSuffix(String? filename) => filename?.split('_').last;

  /// Mengubah filename dengan format seperti ini
  /// e.g. `"gp0_30-07-2025_17-00-00_photo.jpg"`
  static String galleryFilename({
    required String imagePath,
    required int index,
  }) {
    final date = DateTimeFormatter.toFilename(DateTime.now());
    final name = _sanitize(p.basename(imagePath));
    return 'gp${index}_${date}_$name';
  }

  /// Mengubah filename yang telah di [_sanitize] dengan tambahan [prefix].
  static String thumbnailFilename(String imagePath, {String? prefix}) {
    final name = _sanitize(p.basename(imagePath));
    return prefix != null ? '${prefix}_$name' : name;
  }

  /// Mengubah karakter filename yang tidak aman menjadi underscore.
  static String _sanitize(String filename) {
    final dot = filename.lastIndexOf('.');
    if (dot == -1) {
      throw ArgumentError('Filename must include an extension: "$filename"');
    }

    final name = filename
        .substring(0, dot)
        .replaceAll(RegExp(r'[^\w\-.]'), '_');
    final ext = filename.substring(dot);
    return '$name$ext';
  }
}
