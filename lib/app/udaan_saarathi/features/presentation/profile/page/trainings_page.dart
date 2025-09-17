import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';

class TrainingsFormPage extends StatefulWidget {
  const TrainingsFormPage({super.key});

  @override
  State<TrainingsFormPage> createState() => _TrainingsFormPageState();
}

class _TrainingsFormPageState extends State<TrainingsFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<TrainingForm> trainings = [TrainingForm()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Trainings',
        onSave: _saveTrainings,
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: trainings.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                TrainingCard(
                  training: trainings[index],
                  index: index,
                  showRemoveButton: trainings.length > 1,
                  onRemove: () => _removeTraining(index),
                  onCertificateChanged: (value) =>
                      _updateCertificate(index, value),
                ),
                if (index == trainings.length - 1) ...[
                  const SizedBox(height: 24),
                  AddMoreButton(
                    title: 'Add More Training',
                    color: const Color(0xFF4CAF50),
                    onTap: _addTraining,
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

  void _addTraining() {
    setState(() {
      trainings.add(TrainingForm());
    });
  }

  void _removeTraining(int index) {
    if (trainings.length > 1) {
      setState(() {
        trainings[index].dispose();
        trainings.removeAt(index);
      });
    }
  }

  void _updateCertificate(int index, bool value) {
    setState(() {
      trainings[index].hasCertificate = value;
    });
  }

  void _saveTrainings() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Process the data
      List<Map<String, dynamic>> trainingsData = trainings
          .map((training) => {
                'title': training.titleController.text,
                'provider': training.providerController.text,
                'hours': int.tryParse(training.hoursController.text) ?? 0,
                'certificate': training.hasCertificate,
              })
          .toList();

      print('Trainings data: $trainingsData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Training details saved successfully!'),
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
    for (var training in trainings) {
      training.dispose();
    }
    super.dispose();
  }
}

class TrainingCard extends StatelessWidget {
  final TrainingForm training;
  final int index;
  final bool showRemoveButton;
  final VoidCallback onRemove;
  final Function(bool) onCertificateChanged;

  const TrainingCard({
    super.key,
    required this.training,
    required this.index,
    required this.showRemoveButton,
    required this.onRemove,
    required this.onCertificateChanged,
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
          TrainingCardHeader(
            index: index,
            showRemoveButton: showRemoveButton,
            onRemove: onRemove,
          ),
          const SizedBox(height: 24),
          CustomFormBuilderTextField(
            name: 'title_$index',
            controller: training.titleController,
            label: 'Training Title',
            hint: 'e.g. Advanced Flutter Development',
            icon: Icons.school_outlined,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Training Title'),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'provider_$index',
            controller: training.providerController,
            label: 'Training Provider',
            hint: 'e.g. Google, Coursera, Udemy',
            icon: Icons.business_outlined,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Training Provider'),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            name: 'hours_$index',
            controller: training.hoursController,
            label: 'Duration (Hours)',
            hint: 'e.g. 40',
            icon: Icons.access_time_outlined,
            keyboardType: TextInputType.number,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Duration'),
          ),
          const SizedBox(height: 16),
          CertificateToggle(
            hasCertificate: training.hasCertificate,
            onChanged: onCertificateChanged,
          ),
        ],
      ),
    );
  }
}

class TrainingCardHeader extends StatelessWidget {
  final int index;
  final bool showRemoveButton;
  final VoidCallback onRemove;

  const TrainingCardHeader({
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
            color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.trending_up_outlined,
            color: Color(0xFF4CAF50),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Training ${index + 1}',
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

class CertificateToggle extends StatelessWidget {
  final bool hasCertificate;
  final Function(bool) onChanged;

  const CertificateToggle({
    super.key,
    required this.hasCertificate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_membership_outlined,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certificate Available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'Did you receive a certificate for this training?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CertificateSwitch(
            value: hasCertificate,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class CertificateSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const CertificateSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.9,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4CAF50),
        activeTrackColor: const Color(0xFF4CAF50).withValues(alpha: 0.3),
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[300],
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class TrainingForm {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  bool hasCertificate = false;

  void dispose() {
    titleController.dispose();
    providerController.dispose();
    hoursController.dispose();
  }
}
