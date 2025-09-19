import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/profile_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/providers.dart';

class WorkExperienceFormPage extends ConsumerStatefulWidget {
  const WorkExperienceFormPage({super.key});

  @override
  ConsumerState<WorkExperienceFormPage> createState() => _WorkExperienceFormPageState();
}

class _WorkExperienceFormPageState extends ConsumerState<WorkExperienceFormPage> {
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
              for (var i = 0; i < existingExperiences.length; i++) {
                final e = existingExperiences[i];
                init['title_$i'] = e.title ?? '';
                init['employer_$i'] = e.employer ?? '';
                init['start_date_$i'] = e.startDateAd ?? '';
                init['end_date_$i'] = e.endDateAd ?? '';
                init['months_$i'] = e.months?.toString() ?? '';
                init['description_$i'] = e.description ?? '';
              }
              setState(() {
                experienceCount = existingExperiences.length;
                experiences = List<WorkExperienceForm>.generate(experienceCount, (_) => WorkExperienceForm());
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
            return Column(
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
        // Capture current values before removal
        final current = _formKey.currentState?.value ?? <String, dynamic>{};

        // Remove the ExperienceForm and compact the values after the removed index
        experiences.removeAt(index);
        final oldCount = experienceCount;
        experienceCount = experiences.length;

        final newInit = <String, dynamic>{};
        int newIdx = 0;
        for (int oldIdx = 0; oldIdx < oldCount; oldIdx++) {
          if (oldIdx == index) continue; // skip removed
          newInit['title_$newIdx'] = (current['title_$oldIdx'] as String?) ?? '';
          newInit['employer_$newIdx'] = (current['employer_$oldIdx'] as String?) ?? '';
          newInit['start_date_$newIdx'] = (current['start_date_$oldIdx'] as String?) ?? '';
          newInit['end_date_$newIdx'] = (current['end_date_$oldIdx'] as String?) ?? '';
          newInit['months_$newIdx'] = (current['months_$oldIdx'] as String?) ?? '';
          newInit['description_$newIdx'] = (current['description_$oldIdx'] as String?) ?? '';
          newIdx++;
        }
        _initialValues = newInit;
        // Patch updated values into the form so indices stay aligned
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.patchValue(_initialValues);
        });
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
      final formattedDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        experiences[index].startDate = formattedDate;
      });
      // Update form field
      _formKey.currentState?.fields['start_date_$index']?.didChange(formattedDate);
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
      final formattedDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        experiences[index].endDate = formattedDate;
      });
      // Update form field
      _formKey.currentState?.fields['end_date_$index']?.didChange(formattedDate);
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
            CustomSnackbar.showFailureSnackbar(context, 'Invalid date format for experience ${i+1}');
            return;
          }
          
          if (end.isBefore(start)) {
            CustomSnackbar.showFailureSnackbar(context, 'End date must be after start date for experience ${i+1}');
            return;
          }
        }
      }
      
      // Proceed with saving
      final values = _formKey.currentState!.value;
      final List<Map<String, dynamic>> experienceItems = List.generate(experienceCount, (i) {
        return {
          'title': (values['title_$i'] as String?)?.trim() ?? '',
          'employer': (values['employer_$i'] as String?)?.trim() ?? '',
          'start_date_ad': experiences[i].startDate ?? '',
          'end_date_ad': experiences[i].endDate ?? '',
          'months': int.tryParse((values['months_$i'] as String?)?.trim() ?? '') ?? 0,
          'description': (values['description_$i'] as String?)?.trim() ?? '',
        };
      });

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
      padding: const EdgeInsets.all(24),
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
            name: 'title_$index',
            label: 'Job Title',
            hint: 'e.g. Software Engineer',
            icon: Icons.title,
            validator: (value) => CustomValidator.nameValidator(
                type: 'Job Title', input: value),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'employer_$index',
            label: 'Employer',
            hint: 'e.g. Acme Inc',
            icon: Icons.business,
            validator: (value) => CustomValidator.nameValidator(
                type: 'Employer', input: value),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomDateField(
                  name: 'start_date_$index',
                  label: 'Start Date',
                  hint: 'Select start date',
                  icon: Icons.calendar_today,
                  onTap: onSelectStartDate,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDateField(
                  name: 'end_date_$index',
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
            name: 'months_$index',
            label: 'Duration (Months)',
            hint: 'e.g. 24',
            icon: Icons.schedule,
            keyboardType: TextInputType.number,
            validator: (value) => CustomValidator.nameValidator(
                type: 'Duration', input: value),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'description_$index',
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
  String? startDate; // Store as 'yyyy-MM-dd'
  String? endDate;   // Store as 'yyyy-MM-dd'
}
