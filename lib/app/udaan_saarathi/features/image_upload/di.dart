import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/image_pick_and_crop_service.dart';

final imagePickerProvider = Provider((ref) => ImagePicker());
final imageCropperProvider = Provider((ref) => ImageCropper());
final imagePickAndCropServiceProvider = Provider(
  (ref) => ImagePickerServiceImpl(
    imagePicker: ref.read(imagePickerProvider),
    imageCropper: ref.read(imageCropperProvider),
  ),
);
