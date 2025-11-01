import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/image_pick_and_crop_service.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/image_upload/di.dart';

class ImagePickAndCropNotifier extends ChangeNotifier {
  late ImagePickAndCropService imagePickerService;

  ImagePickAndCropNotifier({required this.imagePickerService});

  Future<CroppedFile?> pickAndCropImage({
    List<CropAspectRatioPreset>? imageRatioPresets,
    required ImageSource imageSource,
  }) async {
    return await imagePickerService.pickAndCropImage(
      imageRatioPresets: imageRatioPresets,
      imageSource: imageSource,
    );
  }
}

final imagePickAndCropProvider = ChangeNotifierProvider(
  (ref) => ImagePickAndCropNotifier(
    imagePickerService: ref.read(imagePickAndCropServiceProvider),
  ),
);
