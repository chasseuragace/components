import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/preferences/repository_impl_fake.dart';

import 'multi_select_section.dart'; // import your MultiSelectSection widget
import 'step_header.dart'; // make sure you import your StepHeader widget

class SelectCountries extends StatelessWidget {
  final List<String> selectedCountries;
  final List<String> selectedWorkLocations;
  final Function(List<String>, String) onToggleSelection;

  const SelectCountries({
    super.key,
    required this.selectedCountries,
    required this.selectedWorkLocations,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Choose Your Target Countries',
            subtitle: 'Select Gulf countries where you want to work.',
            icon: Icons.public,
            color: const Color(0xFF059669),
          ),
          const SizedBox(height: 24),

          // Gulf Countries Section
          MultiSelectSection(
            title: 'Gulf Countries',
            options: gulfCountries,
            selected: selectedCountries,
            onToggle: (country) =>
                onToggleSelection(selectedCountries, country),
            color: const Color(0xFF059669),
          ),

          const SizedBox(height: 24),

          // Work Locations Section
          MultiSelectSection(
            title: 'Preferred Work Locations',
            options: workLocations,
            selected: selectedWorkLocations,
            onToggle: (location) =>
                onToggleSelection(selectedWorkLocations, location),
            color: const Color(0xFF0891B2),
          ),
        ],
      ),
    );
  }
}
