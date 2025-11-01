import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  final IconData? icon;

  const DetailRow(
      {super.key,
      required this.label,
      required this.value,
      this.isHighlight = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 12),
          ],
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: isHighlight
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                  : null,
              decoration: isHighlight
                  ? BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    )
                  : null,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isHighlight
                      ? const Color(0xFF10B981)
                      : const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
