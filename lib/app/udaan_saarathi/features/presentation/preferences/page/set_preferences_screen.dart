import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/list.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/preferences/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/quick_salary_button.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/review_section.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/salary_training_sections.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/training_support_section.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/widgets.dart' hide ReviewSection;
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/models/job_title_models.dart';

import '../../../data/models/job_title/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/common/models/option.dart';
import '../../countries/providers/providers.dart' show getAllCountriesProvider;
import '../providers/preferences_config_provider.dart';
import '../providers/options_provider.dart';
import '../providers/save_preferences_notifier.dart';
import '../providers/job_title_preferences_provider.dart';
import 'providers.dart';

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




  @override
  void initState() {
    super.initState();
    // Template will be loaded from filter provider
    // No need to apply default template here
  }



  /// Apply user preferences (job titles only) from server data
  /// This handles the user's selected job titles with priorities
  void _applyUserPreferences(List<PreferencesEntity> userPrefs) {
    try {
      // Extract job titles from all user preferences with preference IDs
      final jobTitles = <Map<String, dynamic>>[];
      
      for (final pref in userPrefs) {
        final userData = pref.rawJson;
        if (userData.containsKey('title') && userData.containsKey('job_title_id')) {
          jobTitles.add({
            'id': userData['job_title_id'],
            'title': userData['title'],
            'priority': userData['priority'] ?? 0,
            'preferenceId': pref.id, // Include the preference entity ID
          });
        }
      }
      
      // Sort by priority
      jobTitles.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));
      
      print("Applying user job titles: $jobTitles");
      
      // Apply only job titles with preference IDs
      _applyJobTitlesOnly({'jobTitles': jobTitles});
      
      setState(() {});
    } catch (e) {
      print('Failed to apply user preferences: $e');
    }
  }
  
  /// Apply filter data (everything except job titles)
  /// This handles countries, salary range, industries, etc.
  void _applyFilterData(Map<String, dynamic> filterData) {
    try {
      print("Applying filter data: $filterData");
      
      // Apply everything except job titles
      _applyNonJobTitleData(filterData);
      
      setState(() {});
    } catch (e) {
      print('Failed to apply filter data: $e');
    }
  }
  
  /// Apply only job titles from template data
  void _applyJobTitlesOnly(Map<String, dynamic> data) {
    try {
      // Job titles
      final jobTitles = (data['jobTitles'] as List?) ?? const [];
      selectedJobTitles = jobTitles
          .whereType<Map>()
          .map((m) => JobTitleWithPriority(
                jobTitle: JobTitle(
                  id: (m['id'] ?? '').toString(),
                  title: (m['title'] ?? '').toString(),
                  isActive: true,
                ),
                priority: (m['priority'] is num) ? (m['priority'] as num).toInt() : 0,
                preferenceId: m['preferenceId']?.toString(), // Include preference ID
              ))
          .toList();
      _reindexPriorities();
    } catch (e) {
      print('Error applying job titles: $e');
    }
  }
  
  /// Apply non-job-title data from template (countries, salary, etc.)
  void _applyNonJobTitleData(Map<String, dynamic> data) {
    try {
      // Countries
      final countries = (data['countries'] as List?) ?? const [];
      selectedCountries = countries.map((e) {
        if (e is Map) {
          final label = (e['label'] ?? e['name'] ?? '').toString();
          final value = (e['value'] ?? e['id'] ?? '').toString();
          return Option(label: label, value: value);
        }
        return Option(label: e.toString(), value: e.toString());
      }).toList();

      // Salary range
      final sr = data['salaryRange'];
      if (sr is Map) {
        final min = sr['min'];
        final max = sr['max'];
        if (min is num) salaryRange['min'] = min.toDouble();
        if (max is num) salaryRange['max'] = max.toDouble();
         ref.read(salaryRangeProvider.notifier).state = {
          'min': min.toDouble(),
          'max': max.toDouble(),
        };
      }
      
      // Industries
      final industries = data['industries'];
      if (industries is List) {
        selectedIndustries = industries.cast<String>();
      }
      
      // Work locations
      final workLocations = data['workLocations'];
      if (workLocations is List) {
        selectedWorkLocations = workLocations.cast<String>();
      }
      
      // Work culture
      final workCulture = data['workCulture'];
      if (workCulture is List) {
        selectedWorkCulture = workCulture.cast<String>();
      }
      
      // Agencies
      final agencies = data['agencies'];
      if (agencies is List) {
        selectedAgencies = agencies.cast<String>();
      }
      
      // Company size
      final companySize = data['companySize'];
      if (companySize is String) {
        selectedCompanySize = companySize;
      }
      
      // Shift preferences
      final shiftPreferences = data['shiftPreferences'];
      if (shiftPreferences is List) {
        selectedShiftPreferences = shiftPreferences.cast<String>();
      }
      
      // Experience level
      final experienceLevel = data['experienceLevel'];
      if (experienceLevel is String) {
        selectedExperienceLevel = experienceLevel;
      }
      
      // Training support
      final trainingSupportValue = data['trainingSupport'];
      if (trainingSupportValue is bool) {
        trainingSupport = trainingSupportValue;
      }
      
      // Contract duration
      final contractDurationValue = data['contractDuration'];
      if (contractDurationValue is String) {
        contractDuration = contractDurationValue;
      }
      
      // Benefits
      final benefits = data['benefits'];
      if (benefits is List) {
        selectedBenefits = benefits.cast<String>();
      }
      
    } catch (e) {
      print('Error applying non-job-title data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(stepsConfigProvider);
    final filterAsync = ref.watch(filterDataProvider);
    final userPrefsAsync = ref.watch(userPreferencesProvider);
    final saveState = ref.watch(savePreferencesNotifierProvider);
    final jobTitlePrefState = ref.watch(jobTitlePreferencesNotifierProvider);
    
    // Listen to save state changes
    ref.listen<AsyncValue<SavePreferencesState>>(savePreferencesNotifierProvider, (previous, next) {
      next.whenData((state) {
        switch (state.status) {
          case SavePreferencesStatus.success:
            _showSuccessMessage();
            _navigateAfterSave();
            break;
          case SavePreferencesStatus.error:
            _showErrorMessage(state.errorMessage);
            break;
          case SavePreferencesStatus.saving:
          case SavePreferencesStatus.idle:
            break;
        }
      });
    });
    
    // Listen to job title preference state changes
    ref.listen<AsyncValue<JobTitlePreferenceState>>(jobTitlePreferencesNotifierProvider, (previous, next) {
      next.whenData((state) {
        switch (state.status) {
          case JobTitlePreferenceStatus.success:
            _showJobTitleOperationSuccess(state.lastOperation);
            // Refresh the preferences list after successful operation
            ref.invalidate(userPreferencesProvider);
            break;
          case JobTitlePreferenceStatus.error:
            _showJobTitleOperationError(state.errorMessage, state.lastOperation);
            break;
          case JobTitlePreferenceStatus.loading:
          case JobTitlePreferenceStatus.idle:
            break;
        }
      });
    });
    
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
            child: filterAsync.when(
              data: (filterData) {
                // Apply filter data (countries, salary, etc.) when available
                if (filterData != null && !_hasPrefilledData) {
                  _applyFilterData(filterData);
                }
                
                return userPrefsAsync.when(
                  data: (userPrefs) {
                    // Apply user preferences (job titles) - this complements filter data
                    if (userPrefs.isNotEmpty && !_hasPrefilledData) {
                      _applyUserPreferences(userPrefs);
                      _hasPrefilledData = true;
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
                                'Could not load job title preferences. Using filter data only.',
                                style: TextStyle(color: Colors.orange.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: _buildStepContent(steps)),
                    ],
                  ),
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading filter data...'),
                  ],
                ),
              ),
              error: (error, stack) {
                // If filter fails, use default template and continue
                if (!_hasPrefilledData) {
                 
                  _hasPrefilledData = false;
                }
                return userPrefsAsync.when(
                  data: (userPrefs) {
                    _applyUserPreferences(userPrefs);
                                      return _buildStepContent(steps);
                  },
                  loading: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading preferences...'),
                      ],
                    ),
                  ),
                  error: (error, stack) => Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Could not load data. Using defaults.',
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: _buildStepContent(steps)),
                    ],
                  ),
                );
              },
            ),
          ),
          PreferencesBottomNavigation(
            currentStep: currentStep,
            totalSteps: steps.length,
            onPrevious: _previousStep,
            onNext: _nextStep,
            isStepValid: () => _isStepValid(steps),
            isSaving: saveState.whenOrNull(
              data: (state) => state.status == SavePreferencesStatus.saving,
            ) ?? false,
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
    if (source == null) return const [];
    
    // Special case for countries - use the existing countries provider
    if (source == 'gulfCountries') {
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
    }
    
    // Use unified options provider for all other sources
    return ref.watch(optionsBySourceProvider(source));
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
   return SalaryRangeSection();
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
    // Check if already exists locally
    int existingIndex = selectedJobTitles.indexWhere(
      (jt) => jt.jobTitle.id == jobTitle.id,
    );

    if (existingIndex != -1) {
      // Already exists, move to top (re-prioritize)
      setState(() {
        JobTitleWithPriority existing = selectedJobTitles.removeAt(existingIndex);
        selectedJobTitles.insert(0, existing);
        _reindexPriorities();
      });
      
      // Call API to reorder preferences
      final orderedIds = selectedJobTitles.map((jt) => jt.jobTitle.id).toList();
      _reorderJobTitlePreferences(orderedIds);
    } else {
      // Add new job title
      setState(() {
        selectedJobTitles.insert(
          0,
          JobTitleWithPriority(jobTitle: jobTitle, priority: 0),
        );
        _reindexPriorities();
      });
      
      // Call API to add preference
      _addJobTitlePreference(jobTitle, 0);
    }

    HapticFeedback.lightImpact();
  }

  void _removeJobTitle(JobTitleWithPriority jobTitle) {
    setState(() {
      selectedJobTitles.remove(jobTitle);
      _reindexPriorities();
    });

    // Call API to remove preference
    _removeJobTitlePreference(jobTitle.jobTitle.title);

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

    // Call API to reorder preferences with correct preference IDs
    final orderedPreferenceIds = selectedJobTitles
        .where((jt) => jt.preferenceId != null)
        .map((jt) => jt.preferenceId!)
        .toList();
    
    if (orderedPreferenceIds.isNotEmpty) {
      _reorderJobTitlePreferences(orderedPreferenceIds);
    }

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

    // Prepare preferences data
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
      'countries': selectedCountries.map((e) => e.toJson()).toList(),
      'salaryRange': ref.read(salaryRangeProvider),
      'industries': selectedIndustries,
      'workLocations': selectedWorkLocations,
      'workCulture': selectedWorkCulture,
      'agencies': selectedAgencies,
      'companySize': selectedCompanySize,
      'shiftPreferences': selectedShiftPreferences,
      'experienceLevel': selectedExperienceLevel,
      'trainingSupport': trainingSupport,
      'contractDuration': contractDuration,
      'benefits': selectedBenefits,
    };

    // Use async notifier to save preferences
    ref.read(savePreferencesNotifierProvider.notifier).savePreferences(preferences);
  }

  void _showSuccessMessage() {
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
  }

  void _showErrorMessage(String? errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                errorMessage ?? 'Failed to save preferences. Please try again.',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _savePreferences,
        ),
      ),
    );
  }

  void _navigateAfterSave() {
    // Check if we can pop, otherwise navigate to app navigation
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, RouteConstants.kAppNavigation);
    }
  }

  void _showJobTitleOperationSuccess(String? operation) {
    String message = 'Job title preference updated successfully!';
    switch (operation) {
      case 'add':
        message = 'Job title added to preferences!';
        break;
      case 'remove':
        message = 'Job title removed from preferences!';
        break;
      case 'reorder':
        message = 'Job title preferences reordered!';
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showJobTitleOperationError(String? errorMessage, String? operation) {
    String message = 'Failed to update job title preference. Please try again.';
    switch (operation) {
      case 'add':
        message = 'Failed to add job title preference.';
        break;
      case 'remove':
        message = 'Failed to remove job title preference.';
        break;
      case 'reorder':
        message = 'Failed to reorder job title preferences.';
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(errorMessage ?? message),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // API-based job title preference management methods
  void _addJobTitlePreference(JobTitle jobTitle, int priority) {
    ref.read(jobTitlePreferencesNotifierProvider.notifier)
        .addJobTitlePreference(jobTitle.title, priority);
  }

  void _removeJobTitlePreference(String title) {
    ref.read(jobTitlePreferencesNotifierProvider.notifier)
        .removeJobTitlePreference(title);
  }

  void _reorderJobTitlePreferences(List<String> orderedIds) {
    ref.read(jobTitlePreferencesNotifierProvider.notifier)
        .reorderJobTitlePreferences(orderedIds);
  }
}