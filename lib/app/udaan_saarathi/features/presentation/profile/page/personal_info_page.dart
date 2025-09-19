import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/candidate/address.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';
// Swap to candidate providers
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart' as cand;
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/candidate/model.dart';

class PersonalInfoFormPage extends ConsumerStatefulWidget {
  const PersonalInfoFormPage({super.key});

  @override
  ConsumerState<PersonalInfoFormPage> createState() => _PersonalInfoFormPageState();
}

class _PersonalInfoFormPageState extends ConsumerState<PersonalInfoFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _dobController = TextEditingController();
  bool _prefilled = false;
  Map<String, dynamic> _initialValues = {};
  String? _gender;

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for candidate update status
    ref.listen<AsyncValue>(cand.updateCandidateProvider, (previous, next) {
      if (next.isLoading) return;
      if (next.hasError) {
        CustomSnackbar.showFailureSnackbar(context, next.error.toString());
      } else if (previous?.isLoading == true && next.hasValue) {
        CustomSnackbar.showSuccessSnackbar(context, 'Profile updated');
        Navigator.pop(context);
      }
    });

    // Trigger fetch of candidate profile once (repo uses stored candidate_id)
    final candState = ref.watch(cand.getCandidateByIdProvider);
    if (!_prefilled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _prefilled) return;
        ref.read(cand.getCandidateByIdProvider.notifier).getCandidateById('');
      });
    }

    // Prefill personal info from candidate profile
    candState.whenData((item) {
      if (!_prefilled && item != null) {
        final init = <String, dynamic>{
          'full_name': item.fullName ?? '',
          'phone': item.phone ?? '',
          'passport_number': item.passportNumber ?? '',
          'address_name': item.address?.name ?? '',
          'address_lat': item.address?.coordinates?.lat?.toString() ?? '',
          'address_lng': item.address?.coordinates?.lng?.toString() ?? '',
        };
        setState(() {
          _initialValues = init;
          _prefilled = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.patchValue(_initialValues);
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Personal Information',
        onSave: _savePersonalInfo,
        isLoading: ref.watch(cand.updateCandidateProvider).isLoading,
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: _initialValues,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionCard(
              title: 'Personal Details',
              icon: Icons.person_outline,
              children: [
                // Full Name
                CustomFormBuilderTextField(
                  name: 'full_name',
                  label: 'Full Name',
                  hint: 'e.g. John Doe',
                  icon: Icons.person,
                  validator: (value) =>
                      CustomValidator.nameValidator(input: value, type: 'Full Name'),
                ),
                const SizedBox(height: 16),
                // Phone
                CustomFormBuilderTextField(
                  name: 'phone',
                  label: 'Phone',
                  hint: 'e.g. +977 9841000000',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      CustomValidator.phoneValidator(value),
                ),
                const SizedBox(height: 16),
                // Passport Number
                CustomFormBuilderTextField(
                  name: 'passport_number',
                  label: 'Passport Number',
                  hint: 'e.g. P1234567',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                // Address (name)
                CustomFormBuilderTextField(
                  name: 'address_name',
                  label: 'Address Name',
                  hint: 'e.g. Kathmandu',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),
                // Address Coordinates
                Row(
                  children: [
                    Expanded(
                      child: CustomFormBuilderTextField(
                        name: 'address_lat',
                        label: 'Latitude',
                        hint: 'e.g. 27.7172',
                        icon: Icons.map_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomFormBuilderTextField(
                        name: 'address_lng',
                        label: 'Longitude',
                        hint: 'e.g. 85.3240',
                        icon: Icons.map_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _savePersonalInfo() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final v = _formKey.currentState!.value;
      // Build typed address entity
      AddressEntity? address;
      final lat = double.tryParse((v['address_lat'] ?? '').toString());
      final lng = double.tryParse((v['address_lng'] ?? '').toString());
      if ((v['address_name'] ?? '').toString().isNotEmpty || (lat != null && lng != null)) {
        address = AddressEntity(
          name: v['address_name'],
          coordinates: (lat != null && lng != null)
              ? CoordinatesEntity(lat: lat, lng: lng)
              : null,
        );
      }

      final model = CandidateModel(
        id: '', // repo uses stored candidate id
        rawJson: {},
        fullName: v['full_name'],
        phone: v['phone'],
        passportNumber: v['passport_number'],
        address: address,
      );

      await ref.read(cand.updateCandidateProvider.notifier).updateCandidate(model);
    }
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool showDivider;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.showDivider = true,
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
              Icon(icon, color: Colors.blue, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
