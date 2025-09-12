// widgets/common/step_header.dart
import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const StepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// widgets/common/progress_indicator.dart
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
