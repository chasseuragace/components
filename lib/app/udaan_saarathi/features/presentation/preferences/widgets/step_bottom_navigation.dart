// widgets/common/step_header.dart
import 'package:flutter/material.dart';

// widgets/common/bottom_navigation.dart
class StepBottomNavigation extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isStepValid;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const StepBottomNavigation({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isStepValid,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1E88E5)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: currentStep == 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: isStepValid ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
              ),
              child: Text(
                isLastStep ? 'Save Preferences' : 'Next',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
