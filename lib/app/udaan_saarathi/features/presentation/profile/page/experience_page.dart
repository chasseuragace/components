import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/profile_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';

class WorkExperienceFormPage extends ConsumerStatefulWidget {
  const WorkExperienceFormPage({super.key});

  @override
  ConsumerState<WorkExperienceFormPage> createState() =>
      _WorkExperienceFormPageState();
}

class _WorkExperienceFormPageState
    extends ConsumerState<WorkExperienceFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<WorkExperienceForm> experiences = [WorkExperienceForm()];
  int experienceCount = 1;
  bool _prefilled = false;
  Map<String, dynamic> _initialValues = {};

  @override
  Widget build(BuildContext context) {
    // Listen for add/update status to show snackbars and navigate
    ref.listen<AsyncValue<ProfileState>>(profileProvider, (previous, next) {
      next.whenData((state) {
        switch (state.status) {
          case ResponseStates.success:
            CustomSnackbar.showSuccessSnackbar(context, state.message!);
            Navigator.pop(context);
            break;
          case ResponseStates.failure:
            CustomSnackbar.showFailureSnackbar(context, state.errorMessage!);
            break;
          case ResponseStates.loading:
          case ResponseStates.initial:
            break;
        }
      });
    });

    // Prefill experiences from existing profile data once via FormBuilder.initialValue
    final profilesAsync = ref.watch(getAllProfileProvider);
    profilesAsync.whenData((profiles) {
      if (!_prefilled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _prefilled) return;
          if (profiles.isNotEmpty) {
            final profile = profiles.first;
            final existingExperiences = profile.profileBlob?.experience ?? [];
            if (existingExperiences.isNotEmpty) {
              final init = <String, dynamic>{};
              final newForms = <WorkExperienceForm>[];
              for (var i = 0; i < existingExperiences.length; i++) {
                final e = existingExperiences[i];
                final form = WorkExperienceForm();
                // preload dates into form model too
                form.startDate = e.startDateAd;
                form.endDate = e.endDateAd;
                newForms.add(form);
                init['title_${form.id}'] = e.title ?? '';
                init['employer_${form.id}'] = e.employer ?? '';
                init['start_date_${form.id}'] = e.startDateAd ?? '';
                init['end_date_${form.id}'] = e.endDateAd ?? '';
                init['months_${form.id}'] = e.months?.toString() ?? '';
                init['description_${form.id}'] = e.description ?? '';
              }
              setState(() {
                experienceCount = newForms.length;
                experiences = newForms;
                _initialValues = init;
                _prefilled = true;
              });
              // Ensure FormBuilder fields receive values after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formKey.currentState?.patchValue(_initialValues);
              });
            } else {
              setState(() {
                experienceCount = 1;
                experiences = [WorkExperienceForm()];
                _initialValues = {};
                _prefilled = true;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formKey.currentState?.patchValue(_initialValues);
              });
            }
          } else {
            setState(() {
              experienceCount = 1;
              experiences = [WorkExperienceForm()];
              _initialValues = {};
              _prefilled = true;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _formKey.currentState?.patchValue(_initialValues);
            });
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Work Experience',
        onSave: _saveExperiences,
        isLoading: ref.watch(profileProvider).isLoading,
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: _initialValues,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: experienceCount,
          itemBuilder: (context, index) {
            return KeyedSubtree(
              key: experiences[index].widgetKey,
              child: Column(
                children: [
                  ExperienceCard(
                    experience: experiences[index],
                    index: index,
                    showRemoveButton: experienceCount > 1,
                    onRemove: () => _removeExperience(index),
                    onSelectStartDate: () => _selectStartDate(context, index),
                    onSelectEndDate: () => _selectEndDate(context, index),
                  ),
                  if (index == experienceCount - 1) ...[
                    const SizedBox(height: 24),
                    AddMoreButton(
                      title: 'Add More Experience',
                      color: const Color(0xFF4CAF50),
                      onTap: _addExperience,
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _addExperience() {
    setState(() {
      experiences.add(WorkExperienceForm());
      experienceCount = experiences.length;
    });
  }

  void _removeExperience(int index) {
    if (experienceCount > 1) {
      setState(() {
        // Save and remove; field names are ID-based and remain stable
        _formKey.currentState?.save();
        experiences.removeAt(index);
        experienceCount = experiences.length;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        experiences[index].startDate = formattedDate;
      });
      // Update form field (ID-based)
      final id = experiences[index].id;
      _formKey.currentState?.fields['start_date_$id']?.didChange(formattedDate);
    }
  }

  Future<void> _selectEndDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        experiences[index].endDate = formattedDate;
      });
      // Update form field (ID-based)
      final id = experiences[index].id;
      _formKey.currentState?.fields['end_date_$id']?.didChange(formattedDate);
    }
  }

  void _saveExperiences() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Validate dates
      for (var i = 0; i < experienceCount; i++) {
        final startDate = experiences[i].startDate;
        final endDate = experiences[i].endDate;

        if (startDate != null && endDate != null) {
          final start = DateTime.tryParse(startDate);
          final end = DateTime.tryParse(endDate);

          if (start == null || end == null) {
            CustomSnackbar.showFailureSnackbar(
                context, 'Invalid date format for experience ${i + 1}');
            return;
          }

          if (end.isBefore(start)) {
            CustomSnackbar.showFailureSnackbar(context,
                'End date must be after start date for experience ${i + 1}');
            return;
          }
        }
      }

      // Proceed with saving
      final values = _formKey.currentState!.value;
      final List<Map<String, dynamic>> experienceItems = experiences.map((e) {
        return {
          'title': (values['title_${e.id}'] as String?)?.trim() ?? '',
          'employer': (values['employer_${e.id}'] as String?)?.trim() ?? '',
          'start_date_ad': e.startDate ?? '',
          'end_date_ad': e.endDate ?? '',
          'months': int.tryParse(
                  (values['months_${e.id}'] as String?)?.trim() ?? '') ??
              0,
          'description':
              (values['description_${e.id}'] as String?)?.trim() ?? '',
        };
      }).toList();

      await ref.read(profileProvider.notifier).addExperience(experienceItems);
    }
  }
}

class ExperienceCard extends StatelessWidget {
  final WorkExperienceForm experience;
  final int index;
  final bool showRemoveButton;
  final VoidCallback onRemove;
  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectEndDate;

  const ExperienceCard({
    super.key,
    required this.experience,
    required this.index,
    required this.showRemoveButton,
    required this.onRemove,
    required this.onSelectStartDate,
    required this.onSelectEndDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Experience ${index + 1}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              if (showRemoveButton)
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red[400],
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 24),
          CustomFormBuilderTextField(
            key: ValueKey('title_${experience.id}'),
            name: 'title_${experience.id}',
            label: 'Job Title',
            hint: 'e.g. Software Engineer',
            icon: Icons.title,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Job Title', input: value),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            key: ValueKey('employer_${experience.id}'),
            name: 'employer_${experience.id}',
            label: 'Employer',
            hint: 'e.g. Acme Inc',
            icon: Icons.business,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Employer', input: value),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomDateField(
                  key: ValueKey('start_date_${experience.id}'),
                  name: 'start_date_${experience.id}',
                  label: 'Start Date',
                  hint: 'Select start date',
                  icon: Icons.calendar_today,
                  onTap: onSelectStartDate,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDateField(
                  key: ValueKey('end_date_${experience.id}'),
                  name: 'end_date_${experience.id}',
                  label: 'End Date',
                  hint: 'Select end date',
                  icon: Icons.calendar_today,
                  onTap: onSelectEndDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            key: ValueKey('months_${experience.id}'),
            name: 'months_${experience.id}',
            label: 'Duration (Months)',
            hint: 'e.g. 24',
            icon: Icons.schedule,
            keyboardType: TextInputType.number,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Duration', input: value),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            key: ValueKey('description_${experience.id}'),
            name: 'description_${experience.id}',
            label: 'Description',
            hint: 'Responsibilities and achievements',
            icon: Icons.description,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class WorkExperienceForm {
  // Stable ID for field names
  final String id = UniqueKey().toString();
  String? startDate; // Store as 'yyyy-MM-dd'
  String? endDate; // Store as 'yyyy-MM-dd'
  // Stable key for the list item to prevent state shift on deletion
  final Key widgetKey = UniqueKey();
}
