import 'dart:io';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:urflutter_core/src/widgets/image_crop.dart';
import 'package:urflutter_core/src/widgets/notification/notification.dart';
import 'package:urflutter_core/urflutter_config.dart';

class ResultPickImage {
  ResultPickImage({this.originalImage, this.croppedImage});
  final File? originalImage;
  final Uint8List? croppedImage;
}

Future<ResultPickImage?> onPickImage(
  BuildContext context, {
  double? aspectRatio,
}) async {
  if (kIsWeb) {
    await UrNotify.showInfo(
      'Tidak mendukung upload gambar di web',
      duration: const Duration(seconds: 3),
    );
    return null;
  }

  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final fileSize = await file.length();
    final extension = path.extension(file.path).toLowerCase();
    final isJPG = UrFlutterConfig.configurationImage.extImageAllowed.contains(
      extension,
    );
    final isUnderMaxSize =
        fileSize <=
        UrFlutterConfig.configurationImage.maxImageSize * 1024 * 1024;

    if (!isJPG) {
      await UrNotify.showInfo(
        'Hanya file JPG yang diperbolehkan',
        duration: const Duration(seconds: 3),
      );
      return null;
    }

    if (!isUnderMaxSize) {
      await UrNotify.showInfo(
        // ignore: lines_longer_than_80_chars
        'Ukuran file tidak boleh lebih dari ${UrFlutterConfig.configurationImage.maxImageSize} MB',
        duration: const Duration(seconds: 3),
      );
      return null;
    }

    if (!context.mounted) return null;

    final croppedFile = await Navigator.of(context).push<ResultPickImage?>(
      MaterialPageRoute(
        builder: (context) => ImageCrop(
          aspectRatio: aspectRatio ?? 16 / 9,
          imageList: file.readAsBytesSync(),
          onCropped: (result) async {
            // ngehide showLoading di dallam CropperImage
            Navigator.of(context).pop();

            if (result case CropSuccess(:final croppedImage)) {
              if (!context.mounted) return;

              final result = ResultPickImage(
                croppedImage: croppedImage,
                originalImage: file,
              );

              Navigator.of(context).pop(result);
            } else if (result case CropFailure(:final Object cause)) {
              debugPrint('Crop failed: $cause');
            }
          },
        ),
      ),
    );
    return croppedFile;
  } catch (e) {
    if (e is PlatformException) {
      if (e.message != null) {
        if (e.message!.contains('active')) {
          await UrNotify.showInfo('Sedang membuka galeri, tunggu sebentar');
        }
      }
    }
    debugPrint('Error Pick Image :$e');

    return null;
  }
}
