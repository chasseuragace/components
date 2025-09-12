import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/list.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/preferences/repository_impl_fake.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/quick_salary_button.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/review_section.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/training_support_section.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/widgets.dart' hide ReviewSection;
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/models/job_title_models.dart';

import '../../../data/models/job_title/model.dart';
import '../widgets/salary_training_sections.dart';

// Removed conflicting import that defines JobTitle and JobTitleWithPriority
// import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/set_preferences/set_preferences_3.dart';

final currentStepProvider = StateProvider((ref) => 0);

class SetPreferenceScreen extends StatefulWidget {
  const SetPreferenceScreen({super.key});

  @override
  _SetPreferenceScreenState createState() => _SetPreferenceScreenState();
}

class _SetPreferenceScreenState extends State<SetPreferenceScreen> {
  int currentStep = 0;

  // Ordered job titles with priorities
  List<JobTitleWithPriority> selectedJobTitles = [];

  // Other preferences
  List<String> selectedCountries = [];
  List<String> selectedIndustries = [];
  List<String> selectedWorkLocations = [];
  Map<String, double> salaryRange = {'min': 800, 'max': 3000}; // USD monthly
  List<String> selectedWorkCulture = [];
  List<String> selectedAgencies = [];
  String selectedCompanySize = '';
  List<String> selectedShiftPreferences = [];
  String selectedExperienceLevel = '';
  bool trainingSupport = false;
  String contractDuration = '';
  List<String> selectedBenefits = [];


  // Steps configuration: loaded from repository fake's rawJson or falls back
  // to a local default with two built-in steps (job_titles, review) and
  // the middle steps rendered from config sections.
  List<Map<String, dynamic>> get _stepsConfig {
    try {
      final steps = (remoteItems.first.rawJson['steps'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const [];
      if (steps.isNotEmpty) return steps;
    } catch (_) {}

    // Fallback default
    return [
      {
        'type': 'builtin',
        'key': 'job_titles',
        'title': 'Job Titles (Priority Order)'
      },
      {
        'title': 'Countries & Locations',
        'icon': 'public',
        'color': 0xFF059669,
        'sections': [
          {
            'id': 'countries',
            'type': 'multi_select',
            'title': 'Gulf Countries',
            'source': 'gulfCountries',
            'color': 0xFF059669
          },
          {
            'id': 'work_locations',
            'type': 'multi_select',
            'title': 'Preferred Work Locations',
            'source': 'workLocations',
            'color': 0xFF0891B2
          }
        ]
      },
      {
        'title': 'Salary & Work Preferences',
        'icon': 'attach_money',
        'color': 0xFFDC2626,
        'sections': [
          {
            'id': 'salary',
            'type': 'salary_range',
            'title': 'Expected Monthly Salary (USD)',
            'color': 0xFFDC2626
          },
          {
            'id': 'industries',
            'type': 'multi_select',
            'title': 'Industries',
            'source': 'industries',
            'color': 0xFF7C3AED
          },
          {
            'id': 'experience',
            'type': 'single_select',
            'title': 'Experience Level',
            'source': 'experienceLevels',
            'color': 0xFFEA580C
          },
          {
            'id': 'shifts',
            'type': 'multi_select',
            'title': 'Shift Preferences',
            'source': 'shiftPreferences',
            'color': 0xFF0891B2
          }
        ]
      },
      {
        'title': 'Company & Culture',
        'icon': 'business',
        'color': 0xFF7C2D12,
        'sections': [
          {
            'id': 'company_size',
            'type': 'single_select',
            'title': 'Company Size',
            'source': 'companySizes',
            'color': 0xFF7C2D12
          },
          {
            'id': 'work_culture',
            'type': 'multi_select',
            'title': 'Work Culture',
            'source': 'workCulture',
            'color': 0xFF059669
          }
        ]
      },
      {
        'title': 'Contract & Benefits',
        'icon': 'description',
        'color': 0xFF7C3AED,
        'sections': [
          {
            'id': 'contract_duration',
            'type': 'single_select',
            'title': 'Contract Duration',
            'source': 'contractDurations',
            'color': 0xFF7C3AED
          },
          {
            'id': 'benefits',
            'type': 'multi_select',
            'title': 'Desired Work Benefits',
            'source': 'workBenefits',
            'color': 0xFF059669
          }
        ]
      },
      {'type': 'builtin', 'key': 'review', 'title': 'Review & Confirm'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          PreferencesProgressIndicator(
            currentStep: currentStep,
            totalSteps: _stepsConfig.length,
            stepTitle: _getStepTitle(currentStep),
          ),
          Expanded(child: _buildStepContent()),
          PreferencesBottomNavigation(
            currentStep: currentStep,
            totalSteps: _stepsConfig.length,
            onPrevious: _previousStep,
            onNext: _nextStep,
            isStepValid: _isStepValid,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Set Your Job Preferences',
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: _skipToEnd,
          child: Text(
            'Skip',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),
        ),
      ],
    );
  }

  // Progress indicator extracted to PreferencesProgressIndicator

  String _getStepTitle(int step) {
    if (step < 0 || step >= _stepsConfig.length) return '';
    final s = _stepsConfig[step] ;
    return (s['title'] as String?) ?? '';
  }

  Widget _buildStepContent() {
    if (_stepsConfig.isEmpty) return Container();
    final step = _stepsConfig[currentStep] ;
    final type = step['type'] as String?;
    final key = step['key'] as String?;
    if (type == 'builtin' && key == 'job_titles') {
      return _buildJobTitlesStep();
    }
    if (type == 'builtin' && key == 'review') {
      return _buildReviewStep();
    }
    return _buildConfigStep(step);
  }

  Widget _buildConfigStep(Map<String, dynamic> step) {
    final String title = (step['title'] as String?) ?? '';
    final String subtitle = (step['subtitle'] as String?) ?? '';
    final int colorValue = (step['color'] as int?) ?? 0xFF1E88E5;
    final String? iconName = step['icon'] as String?;
    final sections =
        (step['sections'] as List?)?.cast<Map<String, dynamic>>() ?? const [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: title,
            subtitle: subtitle,
            icon: _iconFromName(iconName),
            color: Color(colorValue),
          ),
          SizedBox(height: 24),
          ...sections
              .map((section) => _buildSectionFromConfig(section))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSectionFromConfig(Map<String, dynamic> section) {
    final String type = (section['type'] as String?) ?? '';
    final String title = (section['title'] as String?) ?? '';
    final int colorValue = (section['color'] as int?) ?? 0xFF1E88E5;
    final String id = (section['id'] as String?) ?? '';

    switch (type) {
      case 'multi_select':
        final options = _resolveOptions(section['source'] as String?);
        final selected = _selectedListFor(id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: MultiSelectSection(
            title: title,
            options: options,
            selected: selected,
            onToggle: (value) => _toggleSelection(selected, value),
            color: Color(colorValue),
          ),
        );
      case 'single_select':
        final options = _resolveOptions(section['source'] as String?);
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: SingleSelectSection(
            title: title,
            options: options,
            selected: _selectedValueFor(id),
            onSelect: (value) => setState(() => _setSelectedValue(id, value)),
            color: Color(colorValue),
          ),
        );
      case 'salary_range':
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildSalaryRangeSection(
         
          ),
        );
      case 'toggle':
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: TrainingSupportSection(
          )
        );
      default:
        return SizedBox.shrink();
    }
  }

  IconData _iconFromName(String? name) {
    switch (name) {
      case 'work_outline':
        return Icons.work_outline;
      case 'public':
        return Icons.public;
      case 'attach_money':
        return Icons.attach_money;
      case 'business':
        return Icons.business;
      case 'description':
        return Icons.description;
      case 'check_circle_outline':
        return Icons.check_circle_outline;
      default:
        return Icons.tune;
    }
  }

  List<String> _resolveOptions(String? source) {
    switch (source) {
      case 'gulfCountries':
        return gulfCountries;
      case 'industries':
        return industries;
      case 'workLocations':
        return workLocations;
      case 'experienceLevels':
        return experienceLevels;
      case 'shiftPreferences':
        return shiftPreferences;
      case 'companySizes':
        return companySizes;
      case 'workCulture':
        return workCulture;
      case 'agencies':
        return agencies;
      case 'contractDurations':
        return contractDurations;
      case 'workBenefits':
        return workBenefits;
      default:
        return const [];
    }
  }

  // Selected state mappers for config-driven sections
  List<String> _selectedListFor(String id) {
    switch (id) {
      case 'countries':
        return selectedCountries;
      case 'work_locations':
        return selectedWorkLocations;
      case 'industries':
        return selectedIndustries;
      case 'work_culture':
        return selectedWorkCulture;
      case 'agencies':
        return selectedAgencies;
      case 'shifts':
        return selectedShiftPreferences;
      case 'benefits':
        return selectedBenefits;
      default:
        return <String>[];
    }
  }

  String _selectedValueFor(String id) {
    switch (id) {
      case 'company_size':
        return selectedCompanySize;
      case 'experience':
        return selectedExperienceLevel;
      case 'contract_duration':
        return contractDuration;
      default:
        return '';
    }
  }

  void _setSelectedValue(String id, String value) {
    switch (id) {
      case 'company_size':
        selectedCompanySize = value;
        break;
      case 'experience':
        selectedExperienceLevel = value;
        break;
      case 'contract_duration':
        contractDuration = value;
        break;
    }
  }

  Widget _buildJobTitlesStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Choose Your Preferred Job Titles',
            subtitle:
                'Select and prioritize job titles. Your top choice appears first.',
            icon: Icons.work_outline,
            color: Color(0xFF3B82F6),
          ),

          SizedBox(height: 24),

          // Selected Job Titles (Ordered by Priority)
          if (selectedJobTitles.isNotEmpty) ...[
            Text(
              'Your Preferences (Priority Order)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: AnimatedSize(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                child: ReorderableListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  onReorder: _reorderJobTitles,
                  children: selectedJobTitles.asMap().entries.map((entry) {
                    int index = entry.key;
                    JobTitleWithPriority jobTitle = entry.value;
                
                    return SelectedJobTitleCard(
                      key: ValueKey(jobTitle.jobTitle.id),
                      item: jobTitle,
                      index: index,
                      onRemove: () => _removeJobTitle(jobTitle),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],

          // Available Job Titles by Category
          Text(
            'Available Job Titles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 12),

          JobTitlesByCategory(
            // availableJobTitles: availableJobTitles,
            selectedJobTitles: selectedJobTitles,
            onAdd: _addJobTitle,
          ),
        ],
      ),
    );
  }

  // SelectedJobTitleCard and JobTitlesByCategory extracted to widgets

  // JobTitleChip extracted to widgets/job_title_chip.dart

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Review Your Preferences',
            subtitle: 'Review and confirm your job preferences before saving.',
            icon: Icons.check_circle_outline,
            color: Color(0xFF059669),
          ),

          SizedBox(height: 24),

          // Job Titles Summary
          if (selectedJobTitles.isNotEmpty)
            _buildReviewSection(
              'Job Titles (Priority Order)',
              selectedJobTitles
                  .map(
                    (jt) =>
                        '${selectedJobTitles.indexOf(jt) + 1}. ${jt.jobTitle.title}',
                  )
                  .toList(),
              Color(0xFF3B82F6),
            ),

          // Countries Summary
          if (selectedCountries.isNotEmpty)
            _buildReviewSection(
              'Target Countries',
              selectedCountries,
              Color(0xFF059669),
            ),

          // Salary Summary
          _buildReviewSection(
              'Salary Range',
              [
                'USD ${salaryRange['min']!.round()} - ${salaryRange['max']!.round()} per month',
              ],
              Color(0xFFDC2626)),

          // Other preferences summaries...
          if (selectedIndustries.isNotEmpty)
            _buildReviewSection(
              'Industries',
              selectedIndustries,
              Color(0xFF7C3AED),
            ),

          if (selectedExperienceLevel.isNotEmpty)
            _buildReviewSection(
                'Experience Level',
                [
                  selectedExperienceLevel,
                ],
                Color(0xFFEA580C)),
        ],
      ),
    );
  }

  Widget _buildSalaryRangeSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, color: Color(0xFFDC2626), size: 24),
              SizedBox(width: 8),
              Text(
                'Expected Monthly Salary (USD)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Salary Display
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFDC2626).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minimum',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    Text(
                      'USD ${salaryRange['min']!.round()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 40, color: Color(0xFFE2E8F0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Maximum',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    Text(
                      'USD ${salaryRange['max']!.round()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Salary Range Slider
          RangeSlider(
            values: RangeValues(salaryRange['min']!, salaryRange['max']!),
            min: 200,
            max: 5000,
            divisions: 48,
            activeColor: Color(0xFFDC2626),
            inactiveColor: Color(0xFFE2E8F0),
            labels: RangeLabels(
              'USD ${salaryRange['min']!.round()}',
              'USD ${salaryRange['max']!.round()}',
            ),
            onChanged: (values) {
              setState(() {
                salaryRange['min'] = values.start;
                salaryRange['max'] = values.end;
              });
            },
          ),

          // Quick Select Buttons
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: QuickSalaryButton(
                isSelected:
                    salaryRange['min'] == 400 && salaryRange['max'] == 800,
                label: 'Entry Level',
                min: 400,
                max: 800,
                onTap: () {
                  setState(() {
                    salaryRange['min'] = 400;
                    salaryRange['max'] = 800;
                  });
                },
              )),
              SizedBox(width: 8),
              Expanded(
                  child: QuickSalaryButton(
                isSelected:
                    salaryRange['min'] == 800 && salaryRange['max'] == 1500,
                label: 'Mid Level',
                min: 800,
                max: 1500,
                onTap: () {
                  setState(() {
                    salaryRange['min'] = 800;
                    salaryRange['max'] = 1500;
                  });
                },
              )),
              SizedBox(width: 8),
              Expanded(
                  child: QuickSalaryButton(
                isSelected:
                    salaryRange['min'] == 1500 && salaryRange['max'] == 3000,
                label: 'Senior',
                min: 1500,
                max: 3000,
                onTap: () {
                  setState(() {
                    salaryRange['min'] = 1500;
                    salaryRange['max'] = 3000;
                  });
                },
              )),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildReviewSection(String title, List<String> items, Color color) {
    return ReviewSection(
      color: color,
      items: items,
      title: title,
    );
  }

  // Bottom navigation extracted to PreferencesBottomNavigation widget

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

  // Validation helpers
  bool _isSectionValid(Map<String, dynamic> section) {
    final String type = (section['type'] as String?) ?? '';
    final String id = (section['id'] as String?) ?? '';
    final bool required = (section['required'] as bool?) ?? false;

    if (!required) return true; // only enforce when required

    switch (type) {
      case 'multi_select':
        final list = _selectedListFor(id);
        return list.isNotEmpty;
      case 'single_select':
        final value = _selectedValueFor(id);
        return value.isNotEmpty;
      case 'salary_range':
        // Consider any set range as valid; optionally enforce min<=max
        final min = salaryRange['min'];
        final max = salaryRange['max'];
        return min != null && max != null && min <= max;
      case 'toggle':
        // If requireTrue is set, toggle must be true; else it's always valid
        final requireTrue = (section['requireTrue'] as bool?) ?? false;
        return requireTrue ? trainingSupport == true : true;
      default:
        return true;
    }
  }

  bool _isStepValid() {
    if (_stepsConfig.isEmpty) return true;
    final step = _stepsConfig[currentStep] ;
    final type = step['type'] as String?;
    final key = step['key'] as String?;
    if (type == 'builtin' && key == 'job_titles') {
      return selectedJobTitles.isNotEmpty;
    }
    if (type == 'builtin' && key == 'review') {
      return true;
    }
    final sections =
        (step['sections'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    for (final section in sections) {
      if (!_isSectionValid(section)) return false;
    }
    return true;
  }

  void _nextStep() {
    if (currentStep < _stepsConfig.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      _savePreferences();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _skipToEnd() {
    setState(() {
      currentStep = _stepsConfig.length - 1;
    });
  }

  void _savePreferences() {
    // Validate job titles against active JobTitles
    List<JobTitleWithPriority> validatedTitles =
        selectedJobTitles.where((jt) => jt.jobTitle.isActive).toList();

    // Simulate API call to save preferences
    Map<String, dynamic> preferences = {
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
      'salaryRange': salaryRange,
      'workCulture': selectedWorkCulture,
      'agencies': selectedAgencies,
      'companySize': selectedCompanySize,
      'shiftPreferences': selectedShiftPreferences,
      'experienceLevel': selectedExperienceLevel,
      'trainingSupport': trainingSupport,
      'contractDuration': contractDuration,
      'benefits': selectedBenefits,
    };

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
