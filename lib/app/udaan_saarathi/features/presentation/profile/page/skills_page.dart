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

// Import your custom form field
// import 'custom_form_builder_text_field.dart';

class SkillsFormPage extends ConsumerStatefulWidget {
  const SkillsFormPage({super.key});

  @override
  ConsumerState<SkillsFormPage> createState() => _SkillsFormPageState();
}

class _SkillsFormPageState extends ConsumerState<SkillsFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<SkillForm> skills = [SkillForm()];
  int skillsCount = 1;
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

    // Prefill skills from existing profile data once via FormBuilder.initialValue
    final profilesAsync = ref.watch(getAllProfileProvider);
    profilesAsync.whenData((profiles) {
      if (!_prefilled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _prefilled) return;
          if (profiles.isNotEmpty) {
            final profile = profiles.first;
            final existingSkills = profile.profileBlob?.skills ?? [];
            if (existingSkills.isNotEmpty) {
              final init = <String, dynamic>{};
              for (var i = 0; i < existingSkills.length; i++) {
                final s = existingSkills[i];
                init['title_$i'] = s.title ?? '';
                init['duration_months_$i'] = s.durationMonths?.toString() ?? '';
                init['years_$i'] = s.years?.toString() ?? '';
              }
              setState(() {
                skillsCount = existingSkills.length;
                skills = List<SkillForm>.generate(skillsCount, (_) => SkillForm());
                _initialValues = init;
                _prefilled = true;
              });
              // Ensure FormBuilder fields receive values after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formKey.currentState?.patchValue(_initialValues);
              });
            } else {
              setState(() {
                skillsCount = 1;
                skills = [SkillForm()];
                _initialValues = {};
                _prefilled = true;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formKey.currentState?.patchValue(_initialValues,
                );
              });
            }
          } else {
            setState(() {
              skillsCount = 1;
              skills = [SkillForm()];
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
        title: 'Skills',
        onSave: _saveSkills,
        isLoading: ref.watch(profileProvider).isLoading,
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: _initialValues,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: skillsCount,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SkillCard(
                  skill: skills[index],
                  index: index,
                  showRemoveButton: skillsCount > 1,
                  onRemove: () => _removeSkill(index),
                  onPickDocuments: () => _pickDocuments(index),
                  onRemoveDocument: (docIndex) =>
                      _removeDocument(index, docIndex),
                ),
                if (index == skillsCount - 1) ...[
                  const SizedBox(height: 24),
                  AddMoreButton(
                    title: 'Add More Skills',
                    color: const Color(0xFF9C27B0),
                    onTap: _addSkill,
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

  void _addSkill() {
    setState(() {
      skills.add(SkillForm());
      skillsCount = skills.length;
    });
  }

  void _removeSkill(int index) {
    if (skillsCount > 1) {
      setState(() {
        // Capture current values before removal
        final current = _formKey.currentState?.value ?? <String, dynamic>{};

        // Remove the SkillForm and compact the values after the removed index
        skills.removeAt(index);
        final oldCount = skillsCount;
        skillsCount = skills.length;

        final newInit = <String, dynamic>{};
        int newIdx = 0;
        for (int oldIdx = 0; oldIdx < oldCount; oldIdx++) {
          if (oldIdx == index) continue; // skip removed
          newInit['title_$newIdx'] = (current['title_$oldIdx'] as String?) ?? '';
          newInit['duration_months_$newIdx'] =
              (current['duration_months_$oldIdx'] as String?) ?? '';
          newInit['years_$newIdx'] = (current['years_$oldIdx'] as String?) ?? '';
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

  Future<void> _pickDocuments(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        List<PlatformFile> validFiles = [];

        for (PlatformFile file in result.files) {
          if (file.size <= 5 * 1024 * 1024) {
            // 5MB limit
            validFiles.add(file);
          }
        }

        if (validFiles.isNotEmpty) {
          setState(() {
            skills[index].selectedDocuments.addAll(validFiles);
            skills[index].documentsError = null;
          });
        }

        if (validFiles.length < result.files.length) {
          setState(() {
            skills[index].documentsError =
                'Some files were too large (>5MB) and were not added';
          });
        }
      }
    } catch (e) {
      setState(() {
        skills[index].documentsError = 'Error selecting files';
      });
    }
  }

  void _removeDocument(int skillIndex, int docIndex) {
    setState(() {
      skills[skillIndex].selectedDocuments.removeAt(docIndex);
      if (skills[skillIndex].selectedDocuments.isEmpty) {
        skills[skillIndex].documentsError = null;
      }
    });
  }

  void _saveSkills() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Read values from form state instead of controllers
      final values = _formKey.currentState!.value;
      final List<Map<String, dynamic>> skillsData = List.generate(skillsCount, (i) {
        final title = (values['title_$i'] as String?)?.trim() ?? '';
        final durationStr = (values['duration_months_$i'] as String?)?.trim() ?? '';
        final yearsStr = (values['years_$i'] as String?)?.trim() ?? '';
        return {
          'title': title,
          'duration_months': int.tryParse(durationStr) ?? 0,
          'years': int.tryParse(yearsStr) ?? 0,
          'documents': skills[i].selectedDocuments.map((doc) => doc.path).toList(),
        };
      });

      print('Skills data: $skillsData');
      await ref.read(profileProvider.notifier).addSkills(skillsData);

      // Show success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text('Skills saved successfully!'),
      //     backgroundColor: Colors.green[600],
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      // );

      // Navigate back
      // Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SkillCard extends StatelessWidget {
  final SkillForm skill;
  final int index;
  final bool showRemoveButton;
  final VoidCallback onRemove;
  final VoidCallback onPickDocuments;
  final Function(int) onRemoveDocument;

  const SkillCard({
    super.key,
    required this.skill,
    required this.index,
    required this.showRemoveButton,
    required this.onRemove,
    required this.onPickDocuments,
    required this.onRemoveDocument,
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
          SkillCardHeader(
            index: index,
            showRemoveButton: showRemoveButton,
            onRemove: onRemove,
          ),
          const SizedBox(height: 24),
          CustomFormBuilderTextField(
            name: 'title_$index',
            label: 'Skill/Language Title',
            hint: 'e.g. JavaScript, English, Data Analysis',
            icon: Icons.star_outline,
            validator: (value) => CustomValidator.nameValidator(
                type: 'Skill Title', input: value),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomFormBuilderTextField(
                  name: 'duration_months_$index',
                  label: 'Duration (Months)',
                  hint: 'e.g. 24',
                  icon: Icons.schedule_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => CustomValidator.nameValidator(
                      type: 'Years', input: value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormBuilderTextField(
                  name: 'years_$index',
                  label: 'Experience (Years)',
                  hint: 'e.g. 3',
                  icon: Icons.timeline_outlined,
                  keyboardType: TextInputType.number,
                  // validator: (value) => CustomValidator.nameValidator(
                  //     type: 'Years', input: value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DocumentsSection(
            selectedDocuments: skill.selectedDocuments,
            documentsError: skill.documentsError,
            onPickDocuments: onPickDocuments,
            onRemoveDocument: onRemoveDocument,
          ),
        ],
      ),
    );
  }
}

class SkillCardHeader extends StatelessWidget {
  final int index;
  final bool showRemoveButton;
  final VoidCallback onRemove;

  const SkillCardHeader({
    super.key,
    required this.index,
    required this.showRemoveButton,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.psychology_outlined,
            color: Color(0xFF9C27B0),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Skill ${index + 1}',
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
    );
  }
}

class DocumentsSection extends StatelessWidget {
  final List<PlatformFile> selectedDocuments;
  final String? documentsError;
  final VoidCallback onPickDocuments;
  final Function(int) onRemoveDocument;

  const DocumentsSection({
    super.key,
    required this.selectedDocuments,
    required this.documentsError,
    required this.onPickDocuments,
    required this.onRemoveDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supporting Documents',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DocumentPickerButton(onTap: onPickDocuments),
        if (selectedDocuments.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...selectedDocuments.asMap().entries.map((entry) {
            int docIndex = entry.key;
            PlatformFile document = entry.value;
            return DocumentItem(
              document: document,
              onRemove: () => onRemoveDocument(docIndex),
            );
          }),
        ],
        if (documentsError != null) ...[
          const SizedBox(height: 4),
          Text(
            documentsError!,
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

class DocumentPickerButton extends StatelessWidget {
  final VoidCallback onTap;

  const DocumentPickerButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select certificates or documents',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Icon(
                  Icons.upload_file_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentItem extends StatelessWidget {
  final PlatformFile document;
  final VoidCallback onRemove;

  const DocumentItem({
    super.key,
    required this.document,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF9C27B0).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF9C27B0).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(document.extension),
            color: const Color(0xFF9C27B0),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatFileSize(document.size),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.close,
              color: Colors.grey[600],
              size: 16,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}

class SkillForm {
  List<PlatformFile> selectedDocuments = [];
  String? documentsError;
}
