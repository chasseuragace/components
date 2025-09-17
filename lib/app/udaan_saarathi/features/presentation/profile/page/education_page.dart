import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';

// Import your custom form field
// import 'custom_form_builder_text_field.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

// Reusable Education Card widget
class EducationCard extends StatelessWidget {
  final int index;
  final EducationForm form;
  final VoidCallback? onRemove;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const EducationCard({
    super.key,
    required this.index,
    required this.form,
    this.onRemove,
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
              if (onRemove != null)
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
            controller: form.titleController,
            label: 'Title/Course Name',
            hint: 'e.g. Bachelor of Computer Science',
            icon: Icons.title_outlined,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Course Title'),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'institute_$index',
            controller: form.instituteController,
            label: 'Institute/University',
            hint: 'e.g. Harvard University',
            icon: Icons.account_balance_outlined,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Institute'),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'degree_$index',
            controller: form.degreeController,
            label: 'Degree/Qualification',
            hint: 'e.g. Bachelor\'s Degree',
            icon: Icons.military_tech_outlined,
            validator: (value) => CustomValidator.nameValidator(type: 'Degree'),
          ),
          const SizedBox(height: 16),
          FilePickerField(
            title: 'Document/Certificate',
            selectedFile: form.selectedFile,
            errorText: form.fileError,
            onPick: onPickFile,
            onRemove: onRemoveFile,
          ),
        ],
      ),
    );
  }
}

// Top-level utility to format file sizes for display
String formatFileSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  } else {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// Reusable File Picker field widget
class FilePickerField extends StatelessWidget {
  final String title;
  final PlatformFile? selectedFile;
  final String? errorText;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const FilePickerField({
    super.key,
    required this.title,
    required this.selectedFile,
    required this.errorText,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPick,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedFile != null
                                ? selectedFile!.name
                                : 'Select document or certificate',
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedFile != null
                                  ? Colors.black87
                                  : Colors.grey[500],
                              fontWeight: selectedFile != null
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                          if (selectedFile != null)
                            Text(
                              formatFileSize(selectedFile!.size),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (selectedFile != null)
                      IconButton(
                        onPressed: onRemove,
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    else
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
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
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

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<EducationForm> educations = [EducationForm()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Education',
        onSave: _saveEducations,
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: educations.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                EducationCard(
                  index: index,
                  form: educations[index],
                  onRemove: educations.length > 1
                      ? () => _removeEducation(index)
                      : null,
                  onPickFile: () => _pickFile(index),
                  onRemoveFile: () => _removeFile(index),
                ),
                if (index == educations.length - 1) ...[
                  const SizedBox(height: 24),
                  AddMoreButton(
                    title: 'Add More Education',
                    color: const Color(0xFFFF9800),
                    onTap: _addEducation,
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

  void _addEducation() {
    setState(() {
      educations.add(EducationForm());
    });
  }

  void _removeEducation(int index) {
    if (educations.length > 1) {
      setState(() {
        educations[index].dispose();
        educations.removeAt(index);
      });
    }
  }

  Future<void> _pickFile(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // Check file size (limit to 5MB)
        if (file.size > 5 * 1024 * 1024) {
          setState(() {
            educations[index].fileError = 'File size should be less than 5MB';
          });
          return;
        }

        setState(() {
          educations[index].selectedFile = file;
          educations[index].fileError = null;
        });
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

  void _saveEducations() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Validate that all required files are selected (optional)
      bool hasFileErrors = false;
      for (int i = 0; i < educations.length; i++) {
        if (educations[i].selectedFile == null) {
          setState(() {
            educations[i].fileError = 'Please select a document';
          });
          hasFileErrors = true;
        }
      }

      if (hasFileErrors) {
        return;
      }

      // Process the data
      List<Map<String, dynamic>> educationData = educations
          .map((edu) => {
                'title': edu.titleController.text,
                'institute': edu.instituteController.text,
                'degree': edu.degreeController.text,
                'document': edu.selectedFile?.path ??
                    '', // You might want to upload the file and store the URL
              })
          .toList();

      print('Education data: $educationData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Education details saved successfully!'),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    for (var education in educations) {
      education.dispose();
    }
    super.dispose();
  }
}

class EducationForm {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  PlatformFile? selectedFile;
  String? fileError;

  void dispose() {
    titleController.dispose();
    instituteController.dispose();
    degreeController.dispose();
  }
}
