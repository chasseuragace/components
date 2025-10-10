import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/profile_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';

class TrainingsFormPage extends ConsumerStatefulWidget {
  const TrainingsFormPage({super.key});

  @override
  ConsumerState<TrainingsFormPage> createState() => _TrainingsFormPageState();
}

class _TrainingsFormPageState extends ConsumerState<TrainingsFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<TrainingForm> trainings = [TrainingForm()];
  int trainingCount = 1;
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

    // Prefill trainings from existing profile data once via FormBuilder.initialValue
    final profilesAsync = ref.watch(getAllProfileProvider);
    profilesAsync.whenData((profiles) {
      if (!_prefilled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _prefilled) return;
          if (profiles.isNotEmpty) {
            final profile = profiles.first;
            final existingTrainings = profile.profileBlob?.trainings ?? [];
            if (existingTrainings.isNotEmpty) {
              final init = <String, dynamic>{};
              final newForms = <TrainingForm>[];
              for (var i = 0; i < existingTrainings.length; i++) {
                final t = existingTrainings[i];
                final form = TrainingForm();
                newForms.add(form);
                init['title_${form.id}'] = t.title ?? '';
                init['provider_${form.id}'] = t.provider ?? '';
                init['hours_${form.id}'] = t.hours?.toString() ?? '';
                init['certificate_${form.id}'] = t.certificate ?? false;
              }
              setState(() {
                trainingCount = newForms.length;
                trainings = newForms;
                _initialValues = init;
                _prefilled = true;
              });
              // Ensure FormBuilder fields receive values after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formKey.currentState?.patchValue(_initialValues);
              });
            } else {
              setState(() {
                trainingCount = 1;
                trainings = [TrainingForm()];
                _initialValues = {};
                _prefilled = true;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formKey.currentState?.patchValue(_initialValues);
              });
            }
          } else {
            setState(() {
              trainingCount = 1;
              trainings = [TrainingForm()];
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
        title: 'Trainings',
        onSave: _saveTrainings,
        isLoading: ref.watch(profileProvider).isLoading,
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: _initialValues,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: trainingCount,
          itemBuilder: (context, index) {
            return KeyedSubtree(
              key: trainings[index].widgetKey,
              child: Column(
                children: [
                  TrainingCard(
                    training: trainings[index],
                    index: index,
                    showRemoveButton: trainingCount > 1,
                    onRemove: () => _removeTraining(index),
                    onCertificateChanged: (value) =>
                        _updateCertificate(index, value),
                  ),
                  if (index == trainingCount - 1) ...[
                    const SizedBox(height: 24),
                    AddMoreButton(
                      title: 'Add More Training',
                      color: const Color(0xFF4CAF50),
                      onTap: _addTraining,
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

  void _addTraining() {
    setState(() {
      trainings.add(TrainingForm());
      trainingCount = trainings.length;
    });
  }

  void _removeTraining(int index) {
    if (trainingCount > 1) {
      setState(() {
        // Save and remove; field names are ID-based and remain stable
        _formKey.currentState?.save();
        trainings.removeAt(index);
        trainingCount = trainings.length;
      });
    }
  }

  void _updateCertificate(int index, bool? value) {
    if (value != null) {
      setState(() {
        trainings[index].certificate = value;
      });
      // Update form state
      final id = trainings[index].id;
      _formKey.currentState?.fields['certificate_$id']?.didChange(value);
    }
  }

  void _saveTrainings() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Read values from form state
      final values = _formKey.currentState!.value;
      final List<Map<String, dynamic>> trainingsData = trainings.map((t) {
        final title = (values['title_${t.id}'] as String?)?.trim() ?? '';
        final provider = (values['provider_${t.id}'] as String?)?.trim() ?? '';
        final hoursStr = (values['hours_${t.id}'] as String?)?.trim() ?? '';
        final certificate =
            (values['certificate_${t.id}'] as bool?) ?? t.certificate;
        return {
          'title': title,
          'provider': provider,
          'hours': int.tryParse(hoursStr) ?? 0,
          'certificate': certificate,
        };
      }).toList();

      print('Training data: $trainingsData');
      await ref.read(profileProvider.notifier).addTrainings(trainingsData);
    }
  }
}

class TrainingCard extends StatelessWidget {
  final TrainingForm training;
  final int index;
  final bool showRemoveButton;
  final VoidCallback onRemove;
  final ValueChanged<bool?> onCertificateChanged;

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
                  Icons.school_outlined,
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
          ),
          const SizedBox(height: 24),
          CustomFormBuilderTextField(
            key: ValueKey('title_${training.id}'),
            name: 'title_${training.id}',
            label: 'Training Title',
            hint: 'e.g. React Workshop',
            icon: Icons.title,
            validator: (value) => CustomValidator.nameValidator(
                type: 'Training Title', input: value),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            key: ValueKey('provider_${training.id}'),
            name: 'provider_${training.id}',
            label: 'Provider',
            hint: 'e.g. Coursera',
            icon: Icons.business,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Provider', input: value),
          ),
          const SizedBox(height: 16),
          CustomFormBuilderTextField(
            key: ValueKey('hours_${training.id}'),
            name: 'hours_${training.id}',
            label: 'Duration (Hours)',
            hint: 'e.g. 40',
            icon: Icons.timelapse,
            keyboardType: TextInputType.number,
            validator: (value) =>
                CustomValidator.nameValidator(type: 'Duration', input: value),
          ),
          const SizedBox(height: 16),
          FormBuilderCheckbox(
            key: ValueKey('certificate_${training.id}'),
            name: 'certificate_${training.id}',
            title: const Text('I received a certificate for this training'),
            onChanged: onCertificateChanged,
          ),
        ],
      ),
    );
  }
}

class TrainingForm {
  // Stable ID for field names
  final String id = UniqueKey().toString();
  bool certificate = false;
  // Stable key for the list item to prevent state shift on deletion
  final Key widgetKey = UniqueKey();
}
