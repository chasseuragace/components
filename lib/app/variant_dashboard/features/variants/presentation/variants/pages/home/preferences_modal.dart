import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/job_title/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/models/job_title_models.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/job_title_preferences_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/preferences_config_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/job_titles_by_category.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/selected_job_title_card.dart';

class PreferencesModal extends ConsumerStatefulWidget {
  const PreferencesModal({super.key});
  // Changed to ConsumerStatefulWidget
  @override
  _PreferencesModalState createState() => _PreferencesModalState();
}

class _PreferencesModalState extends ConsumerState<PreferencesModal> {
  // Changed to ConsumerState
  // Selected job titles with priorities (local UI state)
  List<JobTitleWithPriority> selectedJobTitles = [];
  bool _hasPrefilledData = false; // guard to prefill from API only once

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch API providers
    final userPrefsAsync = ref.watch(userPreferencesProvider);

    // Listen to job title preference operations to refresh user preferences
    ref.listen(jobTitlePreferencesNotifierProvider, (previous, next) {
      next.whenData((state) {
        if (state.status == JobTitlePreferenceStatus.success) {
          // Refresh the user preferences from API after any successful operation
          ref.invalidate(userPreferencesProvider);
        }
      });
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Job Preferences',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Select your preferred job titles in order of priority',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: userPrefsAsync.when(
              data: (userPrefs) {
                // Prefill selected job titles once from API
                if (!_hasPrefilledData) {
                  _applyUserPreferences(userPrefs);
                  _hasPrefilledData = true;
                }

                return ListView(
                  children: [
                    if (selectedJobTitles.isNotEmpty) ...[
                      Text(
                        'Your Preferences (in priority order)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                        child: ReorderableListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          onReorder: _reorderJobTitles,
                          children:
                              selectedJobTitles.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return SelectedJobTitleCard(
                              key: ValueKey(item.jobTitle.id),
                              item: item,
                              index: index,
                              onRemove: () => _removeJobTitle(item),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    Text(
                      'Available Job Titles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Uses provider internally to fetch available job titles
                    JobTitlesByCategory(
                      selectedJobTitles: selectedJobTitles,
                      onAdd: _addJobTitle,
                    ),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(
                child: Text('Failed to load preferences'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Prefill helpers (mirrors source screen logic) ----
  void _applyUserPreferences(List<dynamic> userPrefs) {
    try {
      final jobTitles = <Map<String, dynamic>>[];
      for (final pref in userPrefs) {
        final raw = pref.rawJson as Map<String, dynamic>;
        if (raw.containsKey('title') && raw.containsKey('job_title_id')) {
          jobTitles.add({
            'id': raw['job_title_id'],
            'title': raw['title'],
            'priority': raw['priority'] ?? 0,
            'preferenceId': pref.id,
          });
        }
      }
      jobTitles.sort(
          (a, b) => (a['priority'] as int).compareTo(b['priority'] as int));
      _applyJobTitlesOnly({'jobTitles': jobTitles});
      setState(() {});
    } catch (_) {}
  }

  void _applyJobTitlesOnly(Map<String, dynamic> data) {
    try {
      final list = (data['jobTitles'] as List?) ?? const [];
      selectedJobTitles = list
          .whereType<Map>()
          .map((m) => JobTitleWithPriority(
                jobTitle: JobTitle(
                  id: (m['id'] ?? '').toString(),
                  title: (m['title'] ?? '').toString(),
                  isActive: true,
                ),
                priority:
                    (m['priority'] is num) ? (m['priority'] as num).toInt() : 0,
                preferenceId: m['preferenceId']?.toString(),
              ))
          .toList();
      _reindexPriorities();
    } catch (_) {}
  }

  void _reindexPriorities() {
    for (int i = 0; i < selectedJobTitles.length; i++) {
      selectedJobTitles[i].priority = i;
    }
  }

  // ---- Actions: add / remove / reorder ----
  void _addJobTitle(JobTitle jobTitle) {
    final existingIndex =
        selectedJobTitles.indexWhere((jt) => jt.jobTitle.id == jobTitle.id);
    if (existingIndex != -1) {
      setState(() {
        final existing = selectedJobTitles.removeAt(existingIndex);
        selectedJobTitles.insert(0, existing);
        _reindexPriorities();
      });
      final orderedPrefIds = selectedJobTitles
          .where((jt) => jt.preferenceId != null)
          .map((jt) => jt.preferenceId!)
          .toList();
      if (orderedPrefIds.isNotEmpty) {
        _reorderJobTitlePreferences(orderedPrefIds);
      }
    } else {
      setState(() {
        selectedJobTitles.insert(
            0, JobTitleWithPriority(jobTitle: jobTitle, priority: 0));
        _reindexPriorities();
      });
      _addJobTitlePreference(jobTitle, 0);
    }
  }

  void _removeJobTitle(JobTitleWithPriority item) {
    setState(() {
      selectedJobTitles.remove(item);
      _reindexPriorities();
    });
    _removeJobTitlePreference(item.jobTitle.title);
  }

  void _reorderJobTitles(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final moved = selectedJobTitles.removeAt(oldIndex);
      selectedJobTitles.insert(newIndex, moved);
      _reindexPriorities();
    });
    final orderedPrefIds = selectedJobTitles
        .where((jt) => jt.preferenceId != null)
        .map((jt) => jt.preferenceId!)
        .toList();
    if (orderedPrefIds.isNotEmpty) {
      _reorderJobTitlePreferences(orderedPrefIds);
    }
  }

  // ---- API calls via notifier ----
  void _addJobTitlePreference(JobTitle jobTitle, int priority) {
    ref
        .read(jobTitlePreferencesNotifierProvider.notifier)
        .addJobTitlePreference(jobTitle.title, priority);
  }

  void _removeJobTitlePreference(String title) {
    ref
        .read(jobTitlePreferencesNotifierProvider.notifier)
        .removeJobTitlePreference(title);
  }

  void _reorderJobTitlePreferences(List<String> orderedIds) {
    ref
        .read(jobTitlePreferencesNotifierProvider.notifier)
        .reorderJobTitlePreferences(orderedIds);
  }
}
