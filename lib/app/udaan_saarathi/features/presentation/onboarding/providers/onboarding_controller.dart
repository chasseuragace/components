import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';

/// Keys for LocalStorage
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
    final storage = ref.read(localStorageProvider);
    final iso = await storage.getString(_kLastOnboardingKey);
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
    final storage = ref.read(localStorageProvider);
    await storage.setString(_kLastOnboardingKey, DateTime.now().toIso8601String());
    // After completion, no need to show until 7 days pass
    state = const AsyncData(false);
  }
}
