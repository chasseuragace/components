import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/profile_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';

import 'skills_page.dart' hide DocumentPickerButton;

class EducationFormPage extends ConsumerStatefulWidget {
  const EducationFormPage({super.key});

  @override
  ConsumerState<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends ConsumerState<EducationFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<EducationForm> educations = [EducationForm()];
  int educationCount = 1;
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

    // Prefill educations from existing profile data once via FormBuilder.initialValue
    final profilesAsync = ref.watch(getAllProfileProvider);
    profilesAsync.whenData((profiles) {
      if (!_prefilled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _prefilled) return;
          if (profiles.isNotEmpty) {
            final profile = profiles.first;
            final existingEducations = profile.profileBlob?.education ?? [];
            if (existingEducations.isNotEmpty) {
              final init = <String, dynamic>{};
              final newForms = <EducationForm>[];
              for (var i = 0; i < existingEducations.length; i++) {
                final e = existingEducations[i];
                final form = EducationForm();
                newForms.add(form);
                init['degree_${form.id}'] = e.degree ?? '';
                init['institute_${form.id}'] = e.institute ?? '';
              }
              setState(() {
                educationCount = newForms.length;
                educations = newForms;
                _initialValues = init;
                _prefilled = true;
              });
              // Ensure FormBuilder fields receive values after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formKey.currentState?.patchValue(_initialValues);
              });
            } else {
              setState(() {
                educationCount = 1;
                educations = [EducationForm()];
                _initialValues = {};
                _prefilled = true;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formKey.currentState?.patchValue(_initialValues);
              });
            }
          } else {
            setState(() {
              educationCount = 1;
              educations = [EducationForm()];
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
        title: 'Education',
        onSave: _saveEducations,
        isLoading: ref.watch(profileProvider).isLoading,
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: _initialValues,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: educationCount,
          itemBuilder: (context, index) {
            return KeyedSubtree(
              key: educations[index].widgetKey,
              child: Column(
                children: [
                  EducationCard(
                    education: educations[index],
                    index: index,
                    showRemoveButton: educationCount > 1,
                    onRemove: () => _removeEducation(index),
                    onPickFile: () => _pickFile(index),
                    onRemoveFile: () => _removeFile(index),
                  ),
                  if (index == educationCount - 1) ...[
                    const SizedBox(height: 24),
                    AddMoreButton(
                      title: 'Add More Education',
                      color: const Color(0xFFFF9800),
                      onTap: _addEducation,
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

  void _addEducation() {
    setState(() {
      educations.add(EducationForm());
      educationCount = educations.length;
    });
  }

  void _removeEducation(int index) {
    if (educationCount > 1) {
      setState(() {
        // Save and simply remove; field names are ID-based and remain stable
        _formKey.currentState?.save();
        educations.removeAt(index);
        educationCount = educations.length;
      });
    }
  }

  Future<void> _pickFile(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.size <= 5 * 1024 * 1024) { // 5MB limit
          setState(() {
            educations[index].selectedFile = file;
            educations[index].fileError = null;
          });
        } else {
          setState(() {
            educations[index].fileError = 'File too large (max 5MB)';
          });
        }
      }
    } catch (e) {
      setState(() {
        educations[index].fileError = 'Error selecting file';
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      educations[index].selectedFile = null;
      educations[index].fileError = null;
    });
  }

  void _saveEducations() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Read values from form state
      final values = _formKey.currentState!.value;
      final List<Map<String, dynamic>> educationItems = educations.map((e) {
        final degree = (values['degree_${e.id}'] as String?)?.trim() ?? '';
        final institute = (values['institute_${e.id}'] as String?)?.trim() ?? '';
        return {
          'degree': degree,
          'institute': institute,
          'document': e.selectedFile?.path,
        };
      }).toList();

      print('Education data: $educationItems');
      await ref.read(profileProvider.notifier).addEducation(educationItems);
    }
  }
}

class EducationCard extends StatelessWidget {
  final EducationForm education;
  final int index;
  final bool showRemoveButton;
  final VoidCallback onRemove;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const EducationCard({
    super.key,
    required this.education,
    required this.index,
    required this.showRemoveButton,
    required this.onRemove,
    required this.onPickFile,
    required this.onRemoveFile,
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
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Color(0xFFFF9800),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Education ${index + 1}',
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
            key: ValueKey('degree_${education.id}'),
            name: 'degree_${education.id}',
            label: 'Degree',
            hint: 'e.g. Bachelor of Science',
            icon: Icons.school,
            validator: (value) => CustomValidator.nameValidator(
                type: 'Degree', input: value),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            key: ValueKey('institute_${education.id}'),
            name: 'institute_${education.id}',
            label: 'Institution',
            hint: 'e.g. University of Example',
            icon: Icons.location_city,
            validator: (value) => CustomValidator.nameValidator(
                type: 'Institution', input: value),
          ),
          const SizedBox(height: 16),
          FilePickerSection(
            selectedFile: education.selectedFile,
            fileError: education.fileError,
            onPickFile: onPickFile,
            onRemoveFile: onRemoveFile,
          ),
        ],
      ),
    );
  }
}

class FilePickerSection extends StatelessWidget {
  final PlatformFile? selectedFile;
  final String? fileError;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const FilePickerSection({
    super.key,
    required this.selectedFile,
    required this.fileError,
    required this.onPickFile,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Degree Certificate',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DocumentPickerButton(onTap: onPickFile),
        if (selectedFile != null) ...[
          const SizedBox(height: 12),
          DocumentItem(
            document: selectedFile!,
            onRemove: onRemoveFile,
          ),
        ],
        if (fileError != null) ...[
          const SizedBox(height: 4),
          Text(
            fileError!,
            style: TextStyle(
              color: Colors.red[400],
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

class EducationForm {
  // Stable ID for field names
  final String id = UniqueKey().toString();
  PlatformFile? selectedFile;
  String? fileError;
  // Stable key for the list item to prevent state shift on deletion
  final Key widgetKey = UniqueKey();
}
