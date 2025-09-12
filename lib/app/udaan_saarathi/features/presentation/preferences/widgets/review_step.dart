import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/preferences/entity.dart';

import 'review_section.dart';
import 'step_header.dart';

class ReviewStep extends StatelessWidget {
  final List<String> selectedCountries;
  final List<String> selectedIndustries;
  final String selectedExperienceLevel;
  final List<JobTitleWithPriority> selectedJobTitles;
  final Map<String, double> salaryRange;

  const ReviewStep({
    super.key,
    required this.selectedCountries,
    required this.selectedIndustries,
    required this.selectedExperienceLevel,
    required this.selectedJobTitles,
    required this.salaryRange,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            title: 'Review Your Preferences',
            subtitle: 'Review and confirm your job preferences before saving.',
            icon: Icons.check_circle_outline,
            color: Color(0xFF059669),
          ),
          const SizedBox(height: 24),

          // Job Titles Summary
          if (selectedJobTitles.isNotEmpty)
            ReviewSection(
              title: 'Job Titles (Priority Order)',
              items: selectedJobTitles
                  .asMap()
                  .entries
                  .map((entry) =>
                      '${entry.key + 1}. ${entry.value.jobTitle.title}')
                  .toList(),
              color: const Color(0xFF3B82F6),
            ),

          // Countries Summary
          if (selectedCountries.isNotEmpty)
            ReviewSection(
              title: 'Target Countries',
              items: selectedCountries,
              color: const Color(0xFF059669),
            ),

          // Salary Summary
          if (salaryRange.isNotEmpty)
            ReviewSection(
              title: 'Salary Range',
              items: [
                'USD ${salaryRange['min']!.round()} - ${salaryRange['max']!.round()} per month',
              ],
              color: const Color(0xFFDC2626),
            ),

          // Industries Summary
          if (selectedIndustries.isNotEmpty)
            ReviewSection(
              title: 'Industries',
              items: selectedIndustries,
              color: const Color(0xFF7C3AED),
            ),

          // Experience Level Summary
          if (selectedExperienceLevel.isNotEmpty)
            ReviewSection(
              title: 'Experience Level',
              items: [selectedExperienceLevel],
              color: const Color(0xFFEA580C),
            ),
        ],
      ),
    );
  }
}
