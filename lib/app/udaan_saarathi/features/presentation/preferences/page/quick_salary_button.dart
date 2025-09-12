import 'package:flutter/material.dart';

class QuickSalaryButton extends StatelessWidget {
  const QuickSalaryButton({
    super.key,
    required this.isSelected,
  required  this.  onTap,
  required this.label,
  required this.min,required this.max,
  });

  final bool isSelected;
  final String label;
final VoidCallback onTap;
final double min,max;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFFDC2626).withOpacity(0.1)
              : Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Color(0xFFDC2626) : Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Color(0xFFDC2626) : Color(0xFF64748B),
              ),
            ),
            Text(
              '${min.round()}-${max.round()}',
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Color(0xFFDC2626) : Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
