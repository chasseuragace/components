import 'package:flutter/material.dart';

class TrainingSupportSection extends StatelessWidget {
  const TrainingSupportSection({
    super.key,
    required this.trainingSupport,
    required this.onToggle,
  });

  final bool trainingSupport;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF059669), size: 24),
              const SizedBox(width: 8),
              const Text(
                'Training Support Required',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: trainingSupport
                    ? const Color(0xFF059669).withOpacity(0.1)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: trainingSupport
                      ? const Color(0xFF059669)
                      : const Color(0xFFE2E8F0),
                  width: trainingSupport ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: trainingSupport
                            ? const Color(0xFF059669)
                            : const Color(0xFFCBD5E1),
                        width: 2,
                      ),
                      color: trainingSupport
                          ? const Color(0xFF059669)
                          : Colors.transparent,
                    ),
                    child: trainingSupport
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yes, I need training support',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'I would like companies that provide job training and skill development',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
