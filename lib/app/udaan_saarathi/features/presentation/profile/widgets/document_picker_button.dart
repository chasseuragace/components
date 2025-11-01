import 'package:flutter/material.dart';

class DocumentPickerButton extends StatelessWidget {
  final VoidCallback onTap;

  const DocumentPickerButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
                  child: Text(
                    'Select certificates or documents',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
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
    );
  }
}
