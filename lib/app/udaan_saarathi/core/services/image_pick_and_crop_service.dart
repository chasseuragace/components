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

  // @override
  // Future<String> compress(XFile image) async {
  //   // // Get the original image file
  //   final originalFile = File(image.path);

  //   // Print the original image size and properties
  //   print("Original Image Size: ${await originalFile.length()} bytes");
  //   print("Original Image Path: ${originalFile.path}");

  //   const quality = 70;
  //   final result = await FlutterImageCompress.compressWithList(
  //     await image.readAsBytes(),
  //     minHeight: 1024,
  //     minWidth: 1024,
  //     quality: quality,
  //   );

  //   // Create a new XFile from the compressed data
  //   final XFile compressed = XFile.fromData(result);
  //   final name = DateTime.now().millisecondsSinceEpoch;

  //   // Save the compressed image
  //   final compressedPath =
  //       "${(await getApplicationDocumentsDirectory()).path}/$name.jpg";
  //   await compressed.saveTo(compressedPath);

  //   // // Get the compressed image file
  //   final compressedFile = File(compressedPath);

  //   // Print the compressed image size and properties
  //   print("Compressed Image Size: ${await compressedFile.length()} bytes");
  //   print("Compressed Image Path: ${compressedFile.path}");

  //   return compressedPath;
  // }
}
