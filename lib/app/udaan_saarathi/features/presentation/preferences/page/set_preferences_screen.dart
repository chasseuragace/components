import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/preferences/repository_impl_fake.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/preferences/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/widgets.dart';

import 'providers.dart';

// Providers moved to providers.dart

class SetPreferenceScreen extends ConsumerStatefulWidget {
  const SetPreferenceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SetPreferenceScreenState createState() => _SetPreferenceScreenState();
}

class _SetPreferenceScreenState extends ConsumerState<SetPreferenceScreen> {
  // Ordered job titles with priorities
  List<JobTitleWithPriority> selectedJobTitles = [];

  // Other preferences
  List<String> selectedCountries = [];
  List<String> selectedIndustries = [];
  List<String> selectedWorkLocations = [];
  List<String> selectedWorkCulture = [];
  List<String> selectedAgencies = [];
  String selectedCompanySize = '';
  List<String> selectedShiftPreferences = [];
  String selectedExperienceLevel = '';
  String contractDuration = '';
  List<String> selectedBenefits = [];

  // Data sources

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentStepProvider);
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: PreferencesAppBar(
        // onBack: () => Navigator.pop(context),
        onSkip: _skipToEnd,
      ),
      body: Column(
        children: [
          StepProgressIndicator(
            currentStep: currentStep,
            totalSteps: 6,
            getStepTitle: (step) => _getStepTitle(step),
          ),
          Expanded(child: _buildStepContent()),
          StepBottomNavigation(
            currentStep: currentStep,
            totalSteps: 6,
            isStepValid: _isStepValid(),
            onPrevious: _previousStep,
            onNext: _nextStep,
          )
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Job Titles (Priority Order)';
      case 1:
        return 'Countries & Locations';
      case 2:
        return 'Salary & Work Preferences';
      case 3:
        return 'Company & Culture';
      case 4:
        return 'Contract & Benefits';
      case 5:
        return 'Review & Confirm';
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    final currentStep = ref.watch(currentStepProvider);
    switch (currentStep) {
      case 0:
        return JobTitlesStep(
          selectedJobTitles: selectedJobTitles,
          availableJobTitles: availableJobTitles,
          onReorder: _reorderJobTitles,
          onRemove: _removeJobTitle,
          onAdd: _addJobTitle,
        );
      case 1:
        return SelectCountries(
          selectedCountries: selectedCountries,
          selectedWorkLocations: selectedWorkLocations,
          onToggleSelection: (list, item) => _toggleSelection(list, item),
        );
      case 2:
        // return _buildSalaryWorkStep();
        return SalaryWorkStep(
          selectedIndustries: selectedIndustries,
          selectedExperienceLevel: selectedExperienceLevel,
          selectedShiftPreferences: selectedShiftPreferences,
          toggleSelection: (list, item) => _toggleSelection(list, item),
          onExperienceLevelSelect: (level) =>
              setState(() => selectedExperienceLevel = level),
        );

      case 3:
        // return _buildCompanyCultureStep();
        return CompanyCultureStep(
          selectedCompanySize: selectedCompanySize,
          selectedWorkCulture: selectedWorkCulture,
          selectedAgencies: selectedAgencies,
          onCompanySizeSelect: (size) =>
              setState(() => selectedCompanySize = size),
          toggleSelection: (list, item) => _toggleSelection(list, item),
        );

      case 4:
        return ContractBenefitsStep(
          contractDuration: contractDuration,
          selectedBenefits: selectedBenefits,
          onContractDurationSelect: (duration) =>
              setState(() => contractDuration = duration),
          toggleSelection: (list, item) => _toggleSelection(list, item),
        );
      case 5:
        return ReviewStep(
          selectedCountries: selectedCountries,
          selectedIndustries: selectedIndustries,
          selectedExperienceLevel: selectedExperienceLevel,
          selectedJobTitles: selectedJobTitles,
          salaryRange: ref.watch(salaryRangeProvider),
        );
      default:
        return Container();
    }
  }

  // Job Title Management Methods
  void _addJobTitle(JobTitle jobTitle) {
    setState(() {
      // Check if already exists
      int existingIndex = selectedJobTitles.indexWhere(
        (jt) => jt.jobTitle.id == jobTitle.id,
      );

      if (existingIndex != -1) {
        // Move to top (re-prioritize)
        JobTitleWithPriority existing = selectedJobTitles.removeAt(
          existingIndex,
        );
        selectedJobTitles.insert(0, existing);
      } else {
        // Add new at top
        selectedJobTitles.insert(
          0,
          JobTitleWithPriority(jobTitle: jobTitle, priority: 0),
        );
      }

      // Reindex priorities
      _reindexPriorities();
    });

    HapticFeedback.lightImpact();
  }

  void _removeJobTitle(JobTitleWithPriority jobTitle) {
    setState(() {
      selectedJobTitles.remove(jobTitle);
      _reindexPriorities();
    });

    HapticFeedback.lightImpact();
  }

  void _reorderJobTitles(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final JobTitleWithPriority item = selectedJobTitles.removeAt(oldIndex);
      selectedJobTitles.insert(newIndex, item);

      _reindexPriorities();
    });

    HapticFeedback.mediumImpact();
  }

  void _reindexPriorities() {
    for (int i = 0; i < selectedJobTitles.length; i++) {
      selectedJobTitles[i].priority = i;
    }
  }

  // Utility Methods
  void _toggleSelection(List<String> list, String item) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else {
        list.add(item);
      }
    });

    HapticFeedback.selectionClick();
  }

  bool _isStepValid() {
    final currentStep = ref.read(currentStepProvider);
    switch (currentStep) {
      case 0:
        return selectedJobTitles.isNotEmpty;
      case 1:
        return selectedCountries.isNotEmpty;
      case 2:
        return selectedIndustries.isNotEmpty &&
            selectedExperienceLevel.isNotEmpty;
      case 3:
        return selectedCompanySize.isNotEmpty;
      case 4:
        return contractDuration.isNotEmpty;
      case 5:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    final currentStep = ref.read(currentStepProvider);
    if (currentStep < 5) {
      ref.read(currentStepProvider.notifier).state = currentStep + 1;
    } else {
      _savePreferences();
    }
  }

  void _previousStep() {
    final currentStep = ref.read(currentStepProvider);
    if (currentStep > 0) {
      ref.read(currentStepProvider.notifier).state = currentStep - 1;
    }
  }

  void _skipToEnd() {
    ref.read(currentStepProvider.notifier).state = 5;
  }

  void _savePreferences() {
    // Validate job titles against active JobTitles
    List<JobTitleWithPriority> validatedTitles =
        selectedJobTitles.where((jt) => jt.jobTitle.isActive).toList();

    // Collect preferences (could be sent to API)
    final sr = ref.read(salaryRangeProvider);
    final ts = ref.read(trainingSupportProvider);
    // ignore: unused_local_variable
    final preferences = {
      'jobTitles': validatedTitles
          .map(
            (jt) => {
              'id': jt.jobTitle.id,
              'title': jt.jobTitle.title,
              'priority': jt.priority,
            },
          )
          .toList(),
      'countries': selectedCountries,
      'industries': selectedIndustries,
      'workLocations': selectedWorkLocations,
      'salaryRange': sr,
      'workCulture': selectedWorkCulture,
      'agencies': selectedAgencies,
      'companySize': selectedCompanySize,
      'shiftPreferences': selectedShiftPreferences,
      'experienceLevel': selectedExperienceLevel,
      'trainingSupport': ts,
      'contractDuration': contractDuration,
      'benefits': selectedBenefits,
    };
    print(preferences);
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Preferences saved successfully!'),
          ],
        ),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Navigate back or to next screen
    // Navigator.pop(context, preferences);
  }
}
