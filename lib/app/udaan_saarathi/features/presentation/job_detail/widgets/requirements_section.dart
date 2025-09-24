import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';

class RequirementsSection extends StatelessWidget {
  final MobileJobEntity job;
  const RequirementsSection({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final allRequirements =
        job.positions.expand((p) => p.requirements).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.checklist_outlined,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          allRequirements.isEmpty
              ? Center(
                  child: Text(
                    "No requirements available",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                )
              : Column(
                  children: allRequirements.asMap().entries.map((entry) {
                    final index = entry.key;
                    final requirement = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                requirement.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF374151),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
        ],
      ),
    );
  }
}
