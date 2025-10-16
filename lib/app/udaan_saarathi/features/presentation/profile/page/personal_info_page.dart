import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/candidate/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/candidate/address.dart';
// Swap to candidate providers
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart'
    as cand;
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';

class PersonalInfoFormPage extends ConsumerStatefulWidget {
  const PersonalInfoFormPage({super.key});

  @override
  ConsumerState<PersonalInfoFormPage> createState() =>
      _PersonalInfoFormPageState();
}

class _PersonalInfoFormPageState extends ConsumerState<PersonalInfoFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _dobController = TextEditingController();
  bool _prefilled = false;
  Map<String, dynamic> _initialValues = {};
  String? _gender;
  AddressEntity? _selectedAddress;

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  // Formats AddressEntity into a human-readable single-line string
  String _formatAddress(AddressEntity? address) {
    if (address == null) return '';
    final parts = <String>[];
    if ((address.name ?? '').trim().isNotEmpty) parts.add(address.name!.trim());
    if ((address.ward ?? '').trim().isNotEmpty)
      parts.add('Ward ${address.ward!.trim()}');
    if ((address.municipality ?? '').trim().isNotEmpty)
      parts.add(address.municipality!.trim());
    if ((address.district ?? '').trim().isNotEmpty)
      parts.add(address.district!.trim());
    if ((address.province ?? '').trim().isNotEmpty)
      parts.add(address.province!.trim());
    return parts.join(', ');
  }

  // Opens a fake location picker (full height) with a search bar and live filtering
  Future<void> _openFakeLocationPicker() async {
    final options = <AddressEntity>[
      AddressEntity(
        name: 'Thamel, Kathmandu',
        coordinates: const CoordinatesEntity(lat: 27.7154, lng: 85.3123),
        province: 'Bagmati',
        district: 'Kathmandu',
        municipality: 'Kathmandu Metropolitan City',
        ward: '26',
      ),
      AddressEntity(
        name: 'Lakeside, Pokhara',
        coordinates: const CoordinatesEntity(lat: 28.2096, lng: 83.9856),
        province: 'Gandaki',
        district: 'Kaski',
        municipality: 'Pokhara Metropolitan City',
        ward: '6',
      ),
      AddressEntity(
        name: 'Biratnagar Bazaar',
        coordinates: const CoordinatesEntity(lat: 26.4525, lng: 87.2718),
        province: 'Koshi',
        district: 'Morang',
        municipality: 'Biratnagar Metropolitan City',
        ward: '8',
      ),
      AddressEntity(
        name: 'Butwal Bazar',
        coordinates: const CoordinatesEntity(lat: 27.7000, lng: 83.4500),
        province: 'Lumbini',
        district: 'Rupandehi',
        municipality: 'Butwal Sub-Metropolitan City',
        ward: '11',
      ),
    ];

    final picked = await showModalBottomSheet<AddressEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final searchController = TextEditingController();
        List<AddressEntity> filtered = List<AddressEntity>.from(options);
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            void applyFilter(String q) {
              final query = q.toLowerCase();
              filtered = options.where((a) {
                final name = (a.name ?? '').toLowerCase();
                final mun = (a.municipality ?? '').toLowerCase();
                final dist = (a.district ?? '').toLowerCase();
                final prov = (a.province ?? '').toLowerCase();
                return name.contains(query) ||
                    mun.contains(query) ||
                    dist.contains(query) ||
                    prov.contains(query);
              }).toList();
              setModalState(() {});
            }

            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Pick location',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(ctx).pop(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        onChanged: applyFilter,
                        decoration: InputDecoration(
                          hintText:
                              'Search province, district, municipality or place',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF2196F3), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final addr = filtered[i];
                          return ListTile(
                            leading: const Icon(Icons.place_outlined,
                                color: Colors.blueGrey),
                            title: Text(addr.name ?? 'Unknown'),
                            subtitle: Text(_formatAddress(addr)),
                            onTap: () => Navigator.of(ctx).pop(addr),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedAddress = picked;
        _initialValues['address_display'] = _formatAddress(picked);
      });
      // Ensure form reflects new address display value
      _formKey.currentState
          ?.patchValue({'address_display': _initialValues['address_display']});
    }
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
        ref.read(cand.getCandidateByIdProvider.notifier).getCandidateById();
      });
    }

    // Prefill personal info from candidate profile
    candState.whenData((item) {
      if (!_prefilled && item != null) {
        final init = <String, dynamic>{
          'full_name': item.fullName ?? '',
          'phone': item.phone ?? '',
          'passport_number': item.passportNumber ?? '',
          'gender': item.gender ?? '',
          'address_display': _formatAddress(item.address),
        };
        setState(() {
          _initialValues = init;
          _prefilled = true;
          _selectedAddress = item.address;
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
                  validator: (value) => CustomValidator.nameValidator(
                      input: value, type: 'Full Name'),
                ),
                const SizedBox(height: 16),
                // Phone
                CustomFormBuilderTextField(
                  name: 'phone',
                  label: 'Phone',
                  hint: 'e.g. +977 9841000000',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) => CustomValidator.phoneValidator(value),
                ),
                const SizedBox(height: 16),
                // Gender (required) - Choice chips in a row (custom styled)
                CustomChoiceChipsField<String>(
                  name: 'gender',
                  label: 'Gender',
                  icon: Icons.wc_outlined,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please select gender'
                      : null,
                  options: const [
                    FormBuilderChipOption(value: 'Male', child: Text('Male')),
                    FormBuilderChipOption(
                        value: 'Female', child: Text('Female')),
                  ],
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
                // Unified Address as a read-only styled field that opens picker
                CustomFormBuilderTextField(
                  name: 'address_display',
                  label: 'Address',
                  hint: 'Pick your address',
                  icon: Icons.location_on_outlined,
                  readOnly: true,
                  onTap: _openFakeLocationPicker,
                  suffixIcon: const Icon(Icons.place_outlined),
                  validator: (v) =>
                      (_selectedAddress == null) ? 'Please pick address' : null,
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
      // Use unified selected address (picked via fake location picker)
      final AddressEntity? address = _selectedAddress;

      final model = CandidateModel(
        id: '', // repo uses stored candidate id
        rawJson: {},
        fullName: v['full_name'],
        phone: v['phone'],
        passportNumber: v['passport_number'],
        gender: (v['gender'] as String?)?.trim().isEmpty == true
            ? null
            : v['gender'] as String?,
        address: address,
      );

      await ref
          .read(cand.updateCandidateProvider.notifier)
          .updateCandidate(model);
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
      padding: const EdgeInsets.all(16),
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
