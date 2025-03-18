import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
    }
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );
    if (file != null) return [file];
    return [];
  }

  Future<CroppedFile?> crop({
    required BuildContext context,
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async =>
      await _imageCropper.cropImage(
        sourcePath: file.path,
        compressQuality: 100,
        uiSettings: [
          WebUiSettings(
            context: context,
          ),
        ],
      );

  Future<XFile> compress(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
          file.path,
          targetPath,
          minHeight: 700,
          minWidth: 700,
          quality: 70,
        ) ??
        XFile('');

    return result;
  }
}
