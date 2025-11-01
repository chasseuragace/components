import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
