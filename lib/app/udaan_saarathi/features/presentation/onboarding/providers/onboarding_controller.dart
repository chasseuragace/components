import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for SharedPreferences
const String _kLastOnboardingKey = 'last_onboarding_completed_at';
const Duration _kOnboardingRepeatAfter = Duration(days: 7);

/// Provider that exposes whether onboarding should be shown (true) or skipped (false)
final onboardingControllerProvider = AsyncNotifierProvider<OnboardingController, bool>(
  OnboardingController.new,
);
// todo write test cases for this controller 
class OnboardingController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    final iso = prefs.getString(_kLastOnboardingKey);
    if (iso == null || iso.isEmpty) {
      // Never completed -> show onboarding
      return true;
    }
    final last = DateTime.tryParse(iso);
    if (last == null) return true;
    final now = DateTime.now();
    final elapsed = now.difference(last);
    return elapsed >= _kOnboardingRepeatAfter;
  }

  /// Call when user finishes onboarding. This updates the timestamp.
  Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastOnboardingKey, DateTime.now().toIso8601String());
    // After completion, no need to show until 7 days pass
    state = const AsyncData(false);
  }
}
