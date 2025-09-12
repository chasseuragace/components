// widgets/common/progress_indicator.dart
import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Function(int) getStepTitle;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.getStepTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              bool isActive = index <= currentStep;
              bool isCompleted = index < currentStep;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : isActive
                            ? const Color(0xFF1E88E5)
                            : const Color(0xFFE2E8F0),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            '${currentStep + 1} of $totalSteps - ${getStepTitle(currentStep)}',
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
