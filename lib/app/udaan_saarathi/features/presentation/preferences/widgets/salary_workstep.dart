import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/preferences/repository_impl_fake.dart';

import 'multi_select_section.dart';
import 'salary_training_sections.dart';
import 'single_select_section.dart';
import 'step_header.dart';

class SalaryWorkStep extends StatelessWidget {
  final List<String> selectedIndustries;
  final String selectedExperienceLevel;
  final List<String> selectedShiftPreferences;

  final void Function(List<String> list, String item) toggleSelection;
  final void Function(String level) onExperienceLevelSelect;

  const SalaryWorkStep({
    super.key,
    required this.selectedIndustries,
    required this.selectedExperienceLevel,
    required this.selectedShiftPreferences,
    required this.toggleSelection,
    required this.onExperienceLevelSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Salary & Work Preferences',
            subtitle: 'Set your salary expectations and work preferences.',
            icon: Icons.attach_money,
            color: const Color(0xFFDC2626),
          ),

          const SizedBox(height: 24),

          // Salary Range Section
          const SalaryRangeSection(),

          const SizedBox(height: 24),

          // Industries Multi-Select
          MultiSelectSection(
            title: 'Industries',
            options: industries,
            selected: selectedIndustries,
            onToggle: (industry) =>
                toggleSelection(selectedIndustries, industry),
            color: const Color(0xFF7C3AED),
          ),

          const SizedBox(height: 24),

          // Experience Level Single-Select
          SingleSelectSection(
            title: 'Experience Level',
            options: experienceLevels,
            selected: selectedExperienceLevel,
            onSelect: (level) => onExperienceLevelSelect(level),
            color: const Color(0xFFEA580C),
          ),

          const SizedBox(height: 24),

          // Shift Preferences Multi-Select
          MultiSelectSection(
            title: 'Shift Preferences',
            options: shiftPreferences,
            selected: selectedShiftPreferences,
            onToggle: (shift) =>
                toggleSelection(selectedShiftPreferences, shift),
            color: const Color(0xFF0891B2),
          ),
        ],
      ),
    );
  }
}
