import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/models/job_title_models.dart';

class JobTitleChip extends StatelessWidget {
  const JobTitleChip({
    super.key,
    required this.job,
    required this.onTap,
  });

  final JobTitle job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_circle_outline, size: 16, color: Color(0xFF1E88E5)),
            const SizedBox(width: 6),
            Text(
              job.title,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
