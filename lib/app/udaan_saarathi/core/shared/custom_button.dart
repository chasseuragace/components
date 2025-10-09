import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/shared/responsive_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.title,
    this.color,
    this.width,
    this.icon,
    this.isLoading = false,
  });

  final Function()? onPressed;
  final String title;
  final Color? color;
  final double? width;
  final Icon? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.kwhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return ResponsiveText(
      title,
      color: AppColors.kwhite,
      fontWeight: FontWeight.w600,
    );
  }
}
