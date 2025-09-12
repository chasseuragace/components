import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/preferences/repository_impl_fake.dart';

import 'multi_select_section.dart';
import 'single_select_section.dart';
import 'step_header.dart';

class ContractBenefitsStep extends StatelessWidget {
  final String contractDuration;
  final List<String> selectedBenefits;

  final void Function(String duration) onContractDurationSelect;
  final void Function(List<String> list, String item) toggleSelection;

  const ContractBenefitsStep({
    super.key,
    required this.contractDuration,
    required this.selectedBenefits,
    required this.onContractDurationSelect,
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
            title: 'Contract & Benefits',
            subtitle: 'Select your contract duration and desired benefits.',
            icon: Icons.description,
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 24),

          // Contract Duration
          SingleSelectSection(
            title: 'Contract Duration',
            options: contractDurations,
            selected: contractDuration,
            onSelect: onContractDurationSelect,
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 24),

          // Desired Work Benefits
          MultiSelectSection(
            title: 'Desired Work Benefits',
            options: workBenefits,
            selected: selectedBenefits,
            onToggle: (benefit) => toggleSelection(selectedBenefits, benefit),
            color: const Color(0xFF059669),
          ),
        ],
      ),
    );
  }
}
