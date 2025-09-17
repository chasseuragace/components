import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';

class WorkExperienceFormPage extends StatefulWidget {
  const WorkExperienceFormPage({super.key});

  @override
  State<WorkExperienceFormPage> createState() => _WorkExperienceFormPageState();
}

class _WorkExperienceFormPageState extends State<WorkExperienceFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<WorkExperienceForm> experiences = [WorkExperienceForm()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Work Experience',
        onSave: _saveExperiences,
      ),

      body: FormBuilder(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: experiences.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ExperienceCard(
                  index: index,
                  form: experiences[index],
                  showRemoveButton: experiences.length > 1,
                  onRemove: () => _removeExperience(index),
                  onSelectStartDate: () => _selectDate(
                      context, experiences[index].startDateController),
                  onSelectEndDate: () => _selectDate(
                      context, experiences[index].endDateController),
                ),
                if (index == experiences.length - 1) ...[
                  const SizedBox(height: 24),
                  AddMoreButton(
                    title: 'Add More Experience',
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
    });
  }

  void _removeExperience(int index) {
    if (experiences.length > 1) {
      setState(() {
        experiences[index].dispose();
        experiences.removeAt(index);
      });
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  void _saveExperiences() {
    if (_formKey.currentState?.validate() ?? false) {
      // Process the data
      List<Map<String, dynamic>> experienceData = experiences
          .map((exp) => {
                'title': exp.titleController.text,
                'employer': exp.employerController.text,
                'start_date_ad': exp.startDateController.text,
                'end_date_ad': exp.endDateController.text,
                'months': int.tryParse(exp.monthsController.text) ?? 0,
                'description': exp.descriptionController.text,
              })
          .toList();

      print('Experience data: $experienceData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Work experience saved successfully!'),
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
    for (var experience in experiences) {
      experience.dispose();
    }
    super.dispose();
  }
}

class WorkExperienceForm {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController employerController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void dispose() {
    titleController.dispose();
    employerController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    monthsController.dispose();
    descriptionController.dispose();
  }
}

// Reusable Experience Card widget
class ExperienceCard extends StatelessWidget {
  final int index;
  final WorkExperienceForm form;
  final bool showRemoveButton;
  final VoidCallback onRemove;
  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectEndDate;

  const ExperienceCard({
    super.key,
    required this.index,
    required this.form,
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
            color: Colors.black.withValues(alpha: 0.04),
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
                  color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Color(0xFF2196F3),
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
            name: 'job_title',
            controller: form.titleController,
            label: 'Job Title',
            hint: 'e.g. Software Engineer',
            icon: Icons.work_outline,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter job title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'employer',
            controller: form.employerController,
            label: 'Company/Employer',
            hint: 'e.g. Google Inc.',
            icon: Icons.business_outlined,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter employer';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomDateField(
                  name: 'start_date',
                  controller: form.startDateController,
                  label: 'Start Date',
                  hint: 'YYYY-MM-DD',
                  icon: Icons.calendar_today_outlined,
                  onTap: onSelectStartDate,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDateField(
                  name: 'end_date',
                  controller: form.endDateController,
                  label: 'End Date',
                  hint: 'YYYY-MM-DD',
                  icon: Icons.event_outlined,
                  onTap: onSelectEndDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'duration',
            controller: form.monthsController,
            label: 'Duration (Months)',
            hint: 'e.g. 12',
            icon: Icons.schedule_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter duration in months';
              }
              if (int.tryParse(value!) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'description',
            controller: form.descriptionController,
            label: 'Description',
            hint: 'Describe your responsibilities and achievements...',
            icon: Icons.description_outlined,
            maxLines: 4,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter job description';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
