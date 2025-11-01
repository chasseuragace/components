import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------- Providers ----------------
final jobTitlesProvider = StateProvider<List<String>>((ref) => []);
final industriesProvider = StateProvider<List<String>>((ref) => []);
final locationsProvider = StateProvider<List<String>>((ref) => []);
final salaryProvider = StateProvider<RangeValues>(
  (ref) => const RangeValues(1000, 5000),
);

final companySizeProvider = StateProvider<String?>((ref) => null);
final workCultureProvider = StateProvider<String?>((ref) => null);
final agenciesProvider = StateProvider<List<String>>((ref) => []);
final shiftProvider = StateProvider<String?>((ref) => null);
final experienceProvider = StateProvider<String?>((ref) => null);

final trainingProvider = StateProvider<bool>((ref) => false);
final contractProvider = StateProvider<String?>((ref) => null);
final relocationProvider = StateProvider<bool>((ref) => false);
final visaProvider = StateProvider<bool>((ref) => false);
final benefitsProvider = StateProvider<List<String>>((ref) => []);

final stepProvider = StateProvider<int>((ref) => 0);

// ---------------- Preference Wizard ----------------
class SetPreferences1 extends ConsumerWidget {
  const SetPreferences1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(stepProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _HeaderStepper(currentStep: step),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: [
                    const Step1Preferences(),
                    const Step2Preferences(),
                    const Step3Preferences(),
                  ][step],
                ),
              ),
            ),
            _BottomButtons(step: step),
          ],
        ),
      ),
    );
  }
}

// ---------------- Header Stepper ----------------
class _HeaderStepper extends StatelessWidget {
  final int currentStep;
  const _HeaderStepper({required this.currentStep});

  final steps = const ["Basics", "Work Style", "Contract"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isActive
                      ? Colors.white
                      : isCompleted
                      ? Colors.green
                      : Colors.white24,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: isActive
                          ? Colors.blue
                          : isCompleted
                          ? Colors.white
                          : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[index],
                  style: TextStyle(
                    color: isActive || isCompleted
                        ? Colors.white
                        : Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ---------------- Bottom Buttons ----------------
class _BottomButtons extends ConsumerWidget {
  final int step;
  const _BottomButtons({required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (step > 0)
            OutlinedButton(
              onPressed: () => ref.read(stepProvider.notifier).state--,
              child: const Text("Back"),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (step < 2) {
                ref.read(stepProvider.notifier).state++;
              } else {
                _showSummary(context, ref);
              }
            },
            child: Text(step < 2 ? "Next" : "Finish"),
          ),
        ],
      ),
    );
  }

  void _showSummary(BuildContext context, WidgetRef ref) {
    final jobTitles = ref.read(jobTitlesProvider);
    final industries = ref.read(industriesProvider);
    final locations = ref.read(locationsProvider);
    final salary = ref.read(salaryProvider);

    final companySize = ref.read(companySizeProvider);
    final workCulture = ref.read(workCultureProvider);
    final agencies = ref.read(agenciesProvider);
    final shift = ref.read(shiftProvider);
    final experience = ref.read(experienceProvider);

    final training = ref.read(trainingProvider);
    final contract = ref.read(contractProvider);
    final relocation = ref.read(relocationProvider);
    final visa = ref.read(visaProvider);
    final benefits = ref.read(benefitsProvider);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Your Preferences"),
        content: SingleChildScrollView(
          child: Text("""
Job Titles: $jobTitles
Industries: $industries
Locations: $locations
Salary: ${salary.start.round()} - ${salary.end.round()}

Company Size: $companySize
Work Culture: $workCulture
Agencies: $agencies
Shift: $shift
Experience: $experience

Training Support: $training
Contract Duration: $contract
Relocation: $relocation
Visa Sponsorship: $visa
Benefits: $benefits
"""),
        ),
      ),
    );
  }
}

// ---------------- Step 1 ----------------
class Step1Preferences extends ConsumerWidget {
  const Step1Preferences({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      key: const ValueKey(1),
      children: [
        _CardSection(
          title: "Job Titles",
          child: _buildChipGroup(
            [
              "Waiter",
              "Driver",
              "Cook",
              "Chef",
              "Gardener",
              "Cleaner",
              "Security Guard",
              "Plumber",
              "Electrician",
              "Construction Worker",
            ],
            ref.watch(jobTitlesProvider),
            ref.read(jobTitlesProvider.notifier),
          ),
        ),
        _CardSection(
          title: "Industries",
          child: _buildChipGroup(
            [
              "Hospitality",
              "Food & Beverage",
              "Construction",
              "Retail",
              "Logistics",
              "Household Services",
              "Security",
            ],
            ref.watch(industriesProvider),
            ref.read(industriesProvider.notifier),
          ),
        ),
        _CardSection(
          title: "Work Locations",
          child: _buildChipGroup(
            ["Qatar", "UAE", "Saudi Arabia", "Kuwait", "Oman", "Bahrain"],
            ref.watch(locationsProvider),
            ref.read(locationsProvider.notifier),
          ),
        ),
        _CardSection(
          title: "Salary Range (QAR)",
          child: RangeSlider(
            values: ref.watch(salaryProvider),
            min: 500,
            max: 10000,
            divisions: 20,
            labels: RangeLabels(
              ref.watch(salaryProvider).start.round().toString(),
              ref.watch(salaryProvider).end.round().toString(),
            ),
            onChanged: (val) => ref.read(salaryProvider.notifier).state = val,
          ),
        ),
      ],
    );
  }
}

// ---------------- Step 2 ----------------
class Step2Preferences extends ConsumerWidget {
  const Step2Preferences({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      key: const ValueKey(2),
      children: [
        _CardSection(
          title: "Company Size",
          child: _buildChoiceGroup(
            ["Small", "Medium", "Large"],
            ref.watch(companySizeProvider),
            ref.read(companySizeProvider.notifier),
          ),
        ),
        _CardSection(
          title: "Work Culture",
          child: _buildChoiceGroup(
            ["Flexible", "Growth-oriented", "Strict"],
            ref.watch(workCultureProvider),
            ref.read(workCultureProvider.notifier),
          ),
        ),
        _CardSection(
          title: "Agencies / Employers",
          child: _buildChipGroup(
            ["Agency A", "Agency B", "Direct Hire"],
            ref.watch(agenciesProvider),
            ref.read(agenciesProvider.notifier),
          ),
        ),
        _CardSection(
          title: "Shift Preference",
          child: _buildChoiceGroup(
            ["Day", "Night", "Rotational"],
            ref.watch(shiftProvider),
            ref.read(shiftProvider.notifier),
          ),
        ),
        _CardSection(
          title: "Experience Level",
          child: _buildChoiceGroup(
            ["Fresher", "1-2 years", "3+ years"],
            ref.watch(experienceProvider),
            ref.read(experienceProvider.notifier),
          ),
        ),
      ],
    );
  }
}

// ---------------- Step 3 ----------------
class Step3Preferences extends ConsumerWidget {
  const Step3Preferences({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      key: const ValueKey(3),
      children: [
        _CardSection(
          title: "Training Support",
          child: SwitchListTile(
            value: ref.watch(trainingProvider),
            onChanged: (val) => ref.read(trainingProvider.notifier).state = val,
            title: const Text("Available"),
          ),
        ),
        _CardSection(
          title: "Contract Duration",
          child: _buildChoiceGroup(
            ["6 months", "1 year", "2 years", "Permanent"],
            ref.watch(contractProvider),
            ref.read(contractProvider.notifier),
          ),
        ),
        _CardSection(
          title: "Relocation",
          child: SwitchListTile(
            value: ref.watch(relocationProvider),
            onChanged: (val) =>
                ref.read(relocationProvider.notifier).state = val,
            title: const Text("Willing to Relocate"),
          ),
        ),
        _CardSection(
          title: "Visa Sponsorship",
          child: SwitchListTile(
            value: ref.watch(visaProvider),
            onChanged: (val) => ref.read(visaProvider.notifier).state = val,
            title: const Text("Required"),
          ),
        ),
        _CardSection(
          title: "Work Benefits",
          child: _buildChipGroup(
            [
              "Health Insurance",
              "Paid Leaves",
              "Accommodation",
              "Food",
              "Transport",
            ],
            ref.watch(benefitsProvider),
            ref.read(benefitsProvider.notifier),
          ),
        ),
      ],
    );
  }
}

// ---------------- Helpers ----------------
class _CardSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _CardSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

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
        onSelected: (_) {
          final updated = [...selected];
          isSelected ? updated.remove(opt) : updated.add(opt);
          notifier.state = updated;
        },
      );
    }).toList(),
  );
}

Widget _buildChoiceGroup(
  List<String> options,
  String? selected,
  StateController<String?> notifier,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: options.map((opt) {
      return ChoiceChip(
        label: Text(opt),
        selected: selected == opt,
        onSelected: (_) => notifier.state = opt,
      );
    }).toList(),
  );
}
