import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------- Providers ----------------
final jobTitlesProvider = StateProvider<List<String>>((ref) => []);
final industriesProvider = StateProvider<List<String>>((ref) => []);
final countriesProvider = StateProvider<List<String>>((ref) => []);
final salaryRangeProvider = StateProvider<RangeValues>(
  (ref) => const RangeValues(800, 3000),
);
final companySizeProvider = StateProvider<String?>((ref) => null);
final shiftProvider = StateProvider<String?>((ref) => null);
final experienceProvider = StateProvider<String?>((ref) => null);
final contractProvider = StateProvider<String?>((ref) => null);
final benefitsProvider = StateProvider<List<String>>((ref) => []);

// ---------------- Root App ----------------
class SetPreferences2 extends StatelessWidget {
  const SetPreferences2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2563EB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF10B981),
        ),
        useMaterial3: true,
      ),
      home: const PreferencesScreen(),
    );
  }
}

// ---------------- Preferences Screen ----------------
class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobTitles = [
      "Waiter",
      "Driver",
      "Plumber",
      "Cook",
      "Chef",
      "Gardener",
      "Cleaner",
      "Security Guard",
      "Electrician",
      "Construction Worker",
      "Salesperson",
    ];

    final industries = [
      "Hospitality",
      "Food & Beverage",
      "Construction",
      "Retail",
      "Transportation",
      "Household Services",
      "Security Services",
    ];

    final countries = [
      "Qatar",
      "UAE (Dubai, Abu Dhabi)",
      "Saudi Arabia",
      "Kuwait",
      "Oman",
      "Bahrain",
    ];

    final companySizes = ["Small", "Medium", "Large"];
    final shifts = ["Day Shift", "Night Shift", "Rotational"];
    final experiences = ["Fresher", "1-2 years", "3+ years"];
    final contracts = ["6 months", "1 year", "2 years", "Permanent"];

    final benefits = [
      "Health Insurance",
      "Paid Leaves",
      "Free Food",
      "Accommodation",
      "Transport Allowance",
    ];

    // Watch selected values
    final selectedJobTitles = ref.watch(jobTitlesProvider);
    final selectedIndustries = ref.watch(industriesProvider);
    final selectedCountries = ref.watch(countriesProvider);
    final salaryRange = ref.watch(salaryRangeProvider);
    final selectedCompanySize = ref.watch(companySizeProvider);
    final selectedShift = ref.watch(shiftProvider);
    final selectedExperience = ref.watch(experienceProvider);
    final selectedContract = ref.watch(contractProvider);
    final selectedBenefits = ref.watch(benefitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Preferences"),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Job Titles"),
          _buildChipGroup(
            jobTitles,
            selectedJobTitles,
            ref.read(jobTitlesProvider.notifier),
          ),

          _sectionTitle("Industries"),
          _buildChipGroup(
            industries,
            selectedIndustries,
            ref.read(industriesProvider.notifier),
          ),

          _sectionTitle("Preferred Countries"),
          _buildChipGroup(
            countries,
            selectedCountries,
            ref.read(countriesProvider.notifier),
          ),

          _sectionTitle("Salary Range (QAR/USD)"),
          RangeSlider(
            values: salaryRange,
            min: 500,
            max: 5000,
            divisions: 9,
            activeColor: const Color(0xFF2563EB),
            labels: RangeLabels(
              "${salaryRange.start.toInt()}",
              "${salaryRange.end.toInt()}",
            ),
            onChanged: (values) =>
                ref.read(salaryRangeProvider.notifier).state = values,
          ),

          _sectionTitle("Company Size"),
          _buildRadioGroup(
            companySizes,
            selectedCompanySize,
            ref.read(companySizeProvider.notifier),
          ),

          _sectionTitle("Shift Preference"),
          _buildRadioGroup(
            shifts,
            selectedShift,
            ref.read(shiftProvider.notifier),
          ),

          _sectionTitle("Experience Level"),
          _buildRadioGroup(
            experiences,
            selectedExperience,
            ref.read(experienceProvider.notifier),
          ),

          _sectionTitle("Contract Duration"),
          _buildRadioGroup(
            contracts,
            selectedContract,
            ref.read(contractProvider.notifier),
          ),

          _sectionTitle("Work Benefits"),
          _buildChipGroup(
            benefits,
            selectedBenefits,
            ref.read(benefitsProvider.notifier),
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final result = {
                "jobTitles": selectedJobTitles,
                "industries": selectedIndustries,
                "countries": selectedCountries,
                "salaryRange": [
                  salaryRange.start.toInt(),
                  salaryRange.end.toInt(),
                ],
                "companySize": selectedCompanySize,
                "shift": selectedShift,
                "experience": selectedExperience,
                "contract": selectedContract,
                "benefits": selectedBenefits,
              };
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Preferences Saved"),
                  content: Text(result.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
            child: const Text("Save Preferences"),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildChipGroup(
    List<String> options,
    List<String> selected,
    StateController<List<String>> notifier,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return FilterChip(
          label: Text(opt),
          selected: isSelected,
          selectedColor: const Color(0xFF2563EB).withOpacity(0.2),
          onSelected: (_) {
            final updated = [...selected];
            isSelected ? updated.remove(opt) : updated.add(opt);
            notifier.state = updated;
          },
        );
      }).toList(),
    );
  }

  Widget _buildRadioGroup(
    List<String> options,
    String? selected,
    StateController<String?> notifier,
  ) {
    return Wrap(
      spacing: 12,
      children: options.map((opt) {
        return ChoiceChip(
          label: Text(opt),
          selected: selected == opt,
          selectedColor: const Color(0xFF10B981).withOpacity(0.2),
          onSelected: (_) => notifier.state = opt,
        );
      }).toList(),
    );
  }
}
