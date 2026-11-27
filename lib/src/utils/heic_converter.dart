import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _heicExtensions = {'.heic', '.heif'};
const _heicBrands = {
  'heic', 'heix', 'heim', 'heis', 'hevc', 'hevx', 'mif1', 'msf1', 'heif', //
};

/// HEIC dikenali dari ekstensi, atau dari isi file (byte 4-7 = "ftyp" dan
/// brand HEIC) supaya tetap terdeteksi walau ekstensinya salah/hilang.
Future<bool> isHeicFile(File file) async {
  if (_heicExtensions.contains(p.extension(file.path).toLowerCase())) {
    return true;
  }

  try {
    final raf = await file.open();
    try {
      final head = await raf.read(12);
      if (head.length < 12) return false;
      final ftyp = String.fromCharCodes(head.sublist(4, 8));
      final brand = String.fromCharCodes(head.sublist(8, 12));
      return ftyp == 'ftyp' && _heicBrands.contains(brand);
    } finally {
      await raf.close();
    }
  } on FileSystemException {
    return false;
  }
}

/// Mengonversi HEIC/HEIF ke JPEG. Orientasi EXIF dinormalkan oleh plugin.
/// Melempar [Exception] bila konversi gagal.
Future<File> convertHeicToJpeg(
  File source, {
  int quality = 90,
  int maxDimension = 1920,
}) async {
  final dir = await getTemporaryDirectory();
  final name = p.basenameWithoutExtension(source.path);
  final target = p.join(
    dir.path,
    '${name}_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );

  final result = await FlutterImageCompress.compressAndGetFile(
    source.path,
    target,
    format: CompressFormat.jpeg,
    quality: quality,
    minWidth: maxDimension,
    minHeight: maxDimension,
  );

  if (result == null) {
    throw Exception('Konversi HEIC gagal');
  }
  return File(result.path);
}
