import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/input_decoration.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required TextEditingController phoneCtrl,
    this.onChange,
  }) : _phoneCtrl = phoneCtrl;

  final TextEditingController _phoneCtrl;
  final Null Function(String phone)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        onChange?.call(value);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: CustomValidator.phoneValidator,
      controller: _phoneCtrl,
      keyboardType: TextInputType.phone,
      decoration: minimalistInputDecoration(
        'Phone number',
        icon: Icons.phone_outlined,
      ),
    );
  }
}
