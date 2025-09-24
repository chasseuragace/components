// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSelectionPrompt extends StatelessWidget {
  const ImageSourceSelectionPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Selct Image",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    ImageSelectionOption(
                      ontap: () {
                        Navigator.of(context).pop(ImageSource.gallery);
                      },
                      iconData: Icons.photo,
                      optionText: "Gallery",
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ImageSelectionOption(
                      ontap: () {
                        Navigator.of(context).pop(ImageSource.camera);
                      },
                      iconData: Icons.camera,
                      optionText: "Camera",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageSelectionOption extends StatelessWidget {
  const ImageSelectionOption({
    super.key,
    this.ontap,
    this.iconData,
    this.optionText,
  });
  final Function()? ontap;
  final IconData? iconData;
  final String? optionText;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: ontap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(iconData, color: const Color(0xFF16A951)),
              const SizedBox(
                width: 4,
              ),
              Text(
                optionText!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
