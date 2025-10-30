import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImagePickAndCropService {
  Future<CroppedFile?> pickAndCropImage({
    List<CropAspectRatioPreset>? imageRatioPresets,
    required ImageSource imageSource,
  });
  // Future<String> compress(XFile image);
}

class ImagePickerServiceImpl implements ImagePickAndCropService {
  final ImagePicker imagePicker;
  final ImageCropper imageCropper;

  ImagePickerServiceImpl({
    required this.imagePicker,
    required this.imageCropper,
  });

  @override
  Future<CroppedFile?> pickAndCropImage({
    List<CropAspectRatioPreset>? imageRatioPresets,
    required ImageSource imageSource,
    bool lockCrop = true,
  }) async {
    CroppedFile? croppedFile;
    final XFile? pickedFile = await imagePicker.pickImage(source: imageSource);
    if (pickedFile != null) {
      croppedFile = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            aspectRatioPresets: imageRatioPresets ??
                [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ],
            showCropGrid: true,
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.orange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: lockCrop,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );
    }
    return croppedFile;
  }

}
