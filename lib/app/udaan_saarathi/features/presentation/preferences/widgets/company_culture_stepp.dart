import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/preferences/repository_impl_fake.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/salary_training_sections.dart';

import 'multi_select_section.dart';
import 'single_select_section.dart';
import 'step_header.dart';

class CompanyCultureStep extends StatelessWidget {
  final String selectedCompanySize;
  final List<String> selectedWorkCulture;
  final List<String> selectedAgencies;

  final void Function(String size) onCompanySizeSelect;
  final void Function(List<String> list, String item) toggleSelection;

  const CompanyCultureStep({
    super.key,
    required this.selectedCompanySize,
    required this.selectedWorkCulture,
    required this.selectedAgencies,
    required this.onCompanySizeSelect,
    required this.toggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Company & Culture Preferences',
            subtitle:
                'Choose your preferred work environment and company type.',
            icon: Icons.business,
            color: const Color(0xFF7C2D12),
          ),
          const SizedBox(height: 24),

          // Company Size
          SingleSelectSection(
            title: 'Company Size',
            options: companySizes,
            selected: selectedCompanySize,
            onSelect: onCompanySizeSelect,
            color: const Color(0xFF7C2D12),
          ),
          const SizedBox(height: 24),

          // Work Culture
          MultiSelectSection(
            title: 'Work Culture',
            options: workCulture,
            selected: selectedWorkCulture,
            onToggle: (culture) =>
                toggleSelection(selectedWorkCulture, culture),
            color: const Color(0xFF059669),
          ),
          const SizedBox(height: 24),

          // Preferred Agencies / Employers
          MultiSelectSection(
            title: 'Preferred Agencies/Employers',
            options: agencies,
            selected: selectedAgencies,
            onToggle: (agency) => toggleSelection(selectedAgencies, agency),
            color: const Color(0xFF0891B2),
          ),
          const SizedBox(height: 24),

          // Training & Support Section
          const TrainingSupportSection(),
        ],
      ),
    );
  }
}
