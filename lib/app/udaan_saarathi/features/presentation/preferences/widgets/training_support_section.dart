import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/providers.dart';

class TrainingSupportSection extends ConsumerWidget {
  const TrainingSupportSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSupport = ref.watch(trainingSupportProvider);

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
            children: const [
              Icon(Icons.school, color: Color(0xFF059669), size: 24),
              SizedBox(width: 8),
              Text(
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
            onTap: () {
              ref.read(trainingSupportProvider.notifier).state = !trainingSupport;
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: trainingSupport ? const Color(0xFF059669).withOpacity(0.1) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: trainingSupport ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
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
                        color: trainingSupport ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
                        width: 2,
                      ),
                      color: trainingSupport ? const Color(0xFF059669) : Colors.transparent,
                    ),
                    child: trainingSupport ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
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
                            color: Color(0xFF475569),
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
