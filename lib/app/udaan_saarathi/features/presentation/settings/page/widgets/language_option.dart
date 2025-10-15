import 'package:flutter/material.dart';

class LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;

  const LanguageOption(this.language, this.isSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(language),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
