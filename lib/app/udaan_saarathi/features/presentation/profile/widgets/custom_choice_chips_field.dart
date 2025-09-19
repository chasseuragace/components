import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomChoiceChipsField<T> extends StatelessWidget {
  final String name;
  final String label;
  final IconData icon;
  final List<FormBuilderChipOption<T>> options;
  final String? Function(T?)? validator;
  final T? initialValue;
  final void Function(T?)? onChanged;

  const CustomChoiceChipsField({
    super.key,
    required this.name,
    required this.label,
    required this.icon,
    required this.options,
    this.validator,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      name: name,
      validator: validator,
      initialValue: initialValue,
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
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
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!, width: 2),
            ),
            labelStyle: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            errorText: field.errorText,
          ),
          child: Row(
            spacing: 18,
           mainAxisAlignment: MainAxisAlignment.center,
           
            children: options.map((opt) {
              final selected = field.value == opt.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical:4.0),
                child: ChoiceChip(
                  label: opt.child ?? Text(opt.value.toString()),
                  selected: selected,
                  onSelected: (val) {
                    final newVal = val ? opt.value : null;
                    field.didChange(newVal);
                    onChanged?.call(newVal);
                  },
                  selectedColor: const Color(0x332196F3),
                  labelStyle: TextStyle(
                    color: selected ? const Color(0xFF2196F3) : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: const StadiumBorder(side: BorderSide(color: Color(0xFF2196F3))),
                  backgroundColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
