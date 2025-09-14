import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/list.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/preferences/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/preferences/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/quick_salary_button.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/review_section.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/training_support_section.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/widgets.dart' hide ReviewSection;
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/models/job_title_models.dart';

import '../../../data/models/job_title/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/common/models/option.dart';
import '../../countries/providers/providers.dart' show getAllCountriesProvider;
import '../providers/providers.dart';
import '../providers/preferences_config_provider.dart';

// Removed conflicting import that defines JobTitle and JobTitleWithPriority
// import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/set_preferences/set_preferences_3.dart';



final currentStepProvider = StateProvider((ref) => 0);

class SetPreferenceScreen extends ConsumerStatefulWidget {

  const SetPreferenceScreen({super.key, });

  @override
  _SetPreferenceScreenState createState() => _SetPreferenceScreenState();
}

class _SetPreferenceScreenState extends ConsumerState<SetPreferenceScreen> {
  int currentStep = 0;

  // Ordered job titles with priorities
  List<JobTitleWithPriority> selectedJobTitles = [];

  // Other preferences
  List<Option> selectedCountries = [];
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
  
  // Track if we've already prefilled from server data
  bool _hasPrefilledData = false;


  // Steps configuration: loaded from provider
  List<Map<String, dynamic>> get _stepsConfig {
    final stepsAsync = ref.watch(stepsConfigProvider);
    return stepsAsync;
  }

  @override
  void initState() {
    super.initState();
    // Apply default template initially
    // This will be overridden by server data if available
    _applyTemplate(_defaultTemplate());
  }

  void _applyTemplate(Map<String, dynamic> tpl) {
    try {
      // Job titles
      final jobTitles = (tpl['jobTitles'] as List?) ?? const [];
      selectedJobTitles = jobTitles
          .whereType<Map>()
          .map((m) => JobTitleWithPriority(
                jobTitle: JobTitle(
                  id: (m['id'] ?? '').toString(),
                  title: (m['title'] ?? '').toString(),
                  isActive: true,
                ),
                priority: (m['priority'] is num) ? (m['priority'] as num).toInt() : 0,
              ))
          .toList();
      _reindexPriorities();

      // Countries
      final countries = (tpl['countries'] as List?) ?? const [];
      selectedCountries = countries.map((e) {
        if (e is Map) {
          final label = (e['label'] ?? e['name'] ?? '').toString();
          final value = (e['value'] ?? e['id'] ?? '').toString();
          return Option(label: label, value: value);
        }
        // Fallback for string-like entries
        return Option(label: e.toString(), value: e.toString());
      }).toList();

      // Salary range
      final sr = tpl['salaryRange'];
      if (sr is Map) {
        final min = sr['min'];
        final max = sr['max'];
        if (min is num) salaryRange['min'] = min.toDouble();
        if (max is num) salaryRange['max'] = max.toDouble();
      }

      setState(() {});
    } catch (_) {
      // Ignore template errors silently for now
    }
  }

  Map<String, dynamic> _defaultTemplate() {
    return {
      'jobTitles': [
        {
          'id': '899033ea-b0c8-4109-93b0-2504809782aa',
          'title': 'Heavy/Trailer Driver',
          'priority': 0,
        }
      ],
      'countries': [
        {
          'label': 'Bulgaria',
          'value': '4b62a218-3849-4909-87bc-6434f07b75d5',
        },
        {
          'label': 'Cyprus',
          'value': '54fb3d0e-f55c-4bc3-97dd-18cb5b406bef',
        },
      ],
      'salaryRange': {
        'min': 800.0,
        'max': 3600.0,
      },
    };
  }

  /// Pre-fill user selections from server data (business requirement)
  /// This is separate from the UI configuration - it's about user's saved preferences
  void _prefillFromUserPreferences(PreferencesEntity userPrefs) {
    try {
      // Extract user data from the server response
      final userData = userPrefs.rawJson;
      
      // Apply the user's saved template/selections
      _applyTemplate(Map<String,dynamic>.from(userData));
      
      // Mark as prefilled to avoid doing this multiple times
      _hasPrefilledData = true;
      
      setState(() {});
    } catch (e) {
      // If prefilling fails, just continue with defaults
      print('Failed to prefill user preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(stepsConfigProvider);
    final userPrefsAsync = ref.watch(userPreferencesProvider);
    
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          PreferencesProgressIndicator(
            currentStep: currentStep,
            totalSteps: steps.length,
            stepTitle: _getStepTitle(currentStep, steps),
          ),
          Expanded(
            child: userPrefsAsync.when(
              data: (userPrefs) {
                // Pre-fill user selections if available
                if (userPrefs != null && !_hasPrefilledData) {
                  _prefillFromUserPreferences(userPrefs);
                }
                return _buildStepContent(steps);
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading your preferences...'),
                  ],
                ),
              ),
              error: (error, stack) => Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Could not load saved preferences. Starting fresh.',
                            style: TextStyle(color: Colors.orange.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildStepContent(steps)),
                ],
              ),
            ),
          ),
          PreferencesBottomNavigation(
            currentStep: currentStep,
            totalSteps: steps.length,
            onPrevious: _previousStep,
            onNext: _nextStep,
            isStepValid: () => _isStepValid(steps),
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

  String _getStepTitle(int step, List<Map<String, dynamic>> steps) {
    if (step < 0 || step >= steps.length) return '';
    final s = steps[step];
    return (s['title'] as String?) ?? '';
  }

  Widget _buildStepContent(List<Map<String, dynamic>> steps) {
    if (steps.isEmpty) return Container();
    final step = steps[currentStep];
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
              ,
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
        final optionObjs = _resolveOptions(section['source'] as String?);
        final selected = _selectedListFor(id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: MultiSelectSection(
            title: title,
            options: optionObjs,
            selected: selected.map((e)=>e.value).toList(),
            onToggle: (value) {
             
              _toggleSelection( selected, optionObjs.firstWhere((e)=>e.value==value));
            },
            color: Color(colorValue),
          ),
        );
      case 'single_select':
        final optionObjs = _resolveOptions(section['source'] as String?);
        final options = optionObjs.map((o) => o.label).toList();
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

  List<Option> _resolveOptions(String? source) {
    switch (source) {
      case 'gulfCountries':
        return ref.watch(getAllCountriesProvider).when(
          data: (data) => data
              .map((e) => Option(
                    label: e.name.toString(),
                    value: e.id.toString(),
                  ))
              .toList(),
          error: (error, s) => const [],
          loading: () => const [],
        );
      // case 'industries':
      //   return industries;
      // case 'workLocations':
      //   return workLocations;
      // case 'experienceLevels':
      //   return experienceLevels;
      // case 'shiftPreferences':
      //   return shiftPreferences;
      // case 'companySizes':
      //   return companySizes;
      // case 'workCulture':
      //   return workCulture;
      // case 'agencies':
      //   return agencies;
      // case 'contractDurations':
      //   return contractDurations;
      // case 'workBenefits':
      //   return workBenefits;
      default:
        return const [];
    }
  }

  // Selected state mappers for config-driven sections
  List<Option> _selectedListFor(String id) {
    switch (id) {
      case 'countries':
        return selectedCountries;
      // case 'work_locations':
      //   return selectedWorkLocations;
      // case 'industries':
      //   return selectedIndustries;
      // case 'work_culture':
      //   return selectedWorkCulture;
      // case 'agencies':
      //   return selectedAgencies;
      // case 'shifts':
      //   return selectedShiftPreferences;
      // case 'benefits':
      //   return selectedBenefits;
      default:
        return [];
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
              selectedCountries.map((e)=>e.label).toList(),
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
  void _toggleSelection(List<Option> list, Option item) {
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

  bool _isStepValid(List<Map<String, dynamic>> steps) {
    if (steps.isEmpty) return true;
    final step = steps[currentStep];
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
    final steps = ref.read(stepsConfigProvider);
    if (currentStep < steps.length - 1) {
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
    final steps = ref.read(stepsConfigProvider);
    setState(() {
      currentStep = steps.length - 1;
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
      'countries': selectedCountries.map((e)=>e.toJson()).toList(),
      'salaryRange': salaryRange,
      
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