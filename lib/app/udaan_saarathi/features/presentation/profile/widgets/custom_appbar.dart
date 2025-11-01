import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/shared/custom_appbar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSave;
  final bool showSave;
  final bool isLoading;
  const CustomAppBar({
    super.key,
    required this.title,
    this.onSave,
    this.showSave = true,
    this.isLoading = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SarathiAppBar(
      title: Text(
        title,
      ),
      actions: showSave
          ? [
              isLoading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: onSave,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),
            ]
          : null,
    );
  }
}
