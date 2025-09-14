import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../page/providers.dart';

class SalaryRangeSection extends ConsumerWidget {
  const SalaryRangeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaryRange = ref.watch(salaryRangeProvider);

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
              Icon(Icons.attach_money, color: Color(0xFFDC2626), size: 24),
              SizedBox(width: 8),
              Text(
                'Expected Monthly Salary (NPR)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Salary Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFDC2626).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Minimum',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    Text(
                      'Rs ${(salaryRange['min']! * 133).round()}',  // Convert USD to NPR (1 USD ≈ 133 NPR)
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Maximum',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    Text(
                      'Rs ${(salaryRange['max']! * 133).round()}',  // Convert USD to NPR (1 USD ≈ 133 NPR)
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Salary Range Slider
          RangeSlider(
            values: RangeValues(salaryRange['min']!, salaryRange['max']!),
            min: 200,
            max: 5000,
            divisions: 48,
            activeColor: const Color(0xFFDC2626),
            inactiveColor: const Color(0xFFE2E8F0),
            labels: RangeLabels(
              'Rs ${(salaryRange['min']! * 133).round()}',
              'Rs ${(salaryRange['max']! * 133).round()}',
            ),
            onChanged: (values) {
              ref.read(salaryRangeProvider.notifier).state = {
                'min': values.start,
                'max': values.end,
              };
            },
          ),

          // Quick Select Buttons
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _QuickSalaryButton(label: 'Entry Level', min: 400, max: 800)),
              SizedBox(width: 8),
              Expanded(child: _QuickSalaryButton(label: 'Mid Level', min: 800, max: 1500)),
              SizedBox(width: 8),
              Expanded(child: _QuickSalaryButton(label: 'Senior', min: 1500, max: 3000)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickSalaryButton extends ConsumerWidget {
  final String label;
  final double min;
  final double max;

  const _QuickSalaryButton({required this.label, required this.min, required this.max});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaryRange = ref.watch(salaryRangeProvider);
    final isSelected = salaryRange['min'] == min && salaryRange['max'] == max;

    return GestureDetector(
      onTap: () {
        ref.read(salaryRangeProvider.notifier).state = {'min': min, 'max': max};
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDC2626).withOpacity(0.1) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFDC2626) : const Color(0xFFE2E8F0),
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
                color: isSelected ? const Color(0xFFDC2626) : const Color(0xFF64748B),
              ),
            ),
            Text(
              '${(min * 133).round()}-${(max * 133).round()}',  // Convert to NPR
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFFDC2626) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
