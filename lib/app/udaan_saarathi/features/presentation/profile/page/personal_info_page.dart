import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/widgets.dart';

class PersonalInfoFormPage extends StatefulWidget {
  const PersonalInfoFormPage({super.key});

  @override
  State<PersonalInfoFormPage> createState() => _PersonalInfoFormPageState();
}

class _PersonalInfoFormPageState extends State<PersonalInfoFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _gender; // Male / Female / Other
  int? _age;

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Personal Information',
        onSave: _savePersonalInfo,
      ),
      body: FormBuilder(
        key: _formKey,
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
                  controller: _fullNameController,
                  label: 'Full Name',
                  hint: 'e.g. Emma Phillips',
                  icon: Icons.person_outline,
                  validator: (value) {
                    return CustomValidator.nameValidator(type: 'Full Name');
                  },
                ),
                const SizedBox(height: 16),

                // Date of Birth
                CustomDateField(
                  name: 'dob',
                  controller: _dobController,
                  label: 'Date of Birth',
                  hint: 'YYYY-MM-DD',
                  icon: Icons.cake_outlined,
                  onTap: _selectDob,
                ),
                if (_age != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Age: $_age years',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Gender
                _GenderDropdown(
                  value: _gender,
                  onChanged: (val) => setState(() => _gender = val),
                ),
                const SizedBox(height: 16),

                // Phone Number
                CustomFormBuilderTextField(
                  name: 'phone',
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'e.g. +1 415 555 0101',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) => CustomValidator.phoneValidator(value),
                ),
                const SizedBox(height: 16),

                // Email
                CustomFormBuilderTextField(
                  name: 'email',
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'e.g. emma@example.com',
                  icon: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => CustomValidator.emailValidator(value),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Optional: Submit button (AppBar already has Save)
            // ElevatedButton(
            //   onPressed: _savePersonalInfo,
            //   child: const Text('Save'),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDob() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
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
      _dobController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() => _age = _calculateAge(picked));
    }
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  void _savePersonalInfo() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = {
        'full_name': _fullNameController.text.trim(),
        'dob': _dobController.text.trim(),
        'age': _age,
        'gender': _gender,
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      };

      // For now, just print. Hook this to your backend/store as needed.
      // ignore: avoid_print
      print('Personal info: $data');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Personal information saved!'),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      Navigator.pop(context);
    }
  }
}

// Generic section card used to group related fields with a header
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
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
                child: Icon(icon, color: const Color(0xFF2196F3), size: 20),
              ),
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

class _GenderDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _GenderDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                'Select gender',
                style: TextStyle(color: Colors.grey[500]),
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[600]),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
