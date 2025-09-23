import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';

class PreferenceChip extends StatelessWidget {
  const PreferenceChip({
    super.key,
    required this.preferenceText,
    this.preferencepriority,
    this.isPriorityReq = true,
  });
  final String preferenceText;
  final String? preferencepriority;
  final bool isPriorityReq;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // colors: [Color(0xFF4F7DF9), Color(0xFF6C5CE7)],
          colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPriorityReq) ...[
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  preferencepriority.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            preferenceText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
