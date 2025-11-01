import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/providers/onboarding_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/preferences_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/preferences_status.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';

class SplashController {
  final Ref ref;

  SplashController(this.ref);

  /// Determine the next route to navigate to based on app state
  Future<String> determineRoute() async {
    try {
      // Ensure auth state is up to date
      await ref.read(authControllerProvider.notifier).checkAuthOnLaunch();
      final authState = ref.read(authControllerProvider);

      if (!authState.isAuthenticated) {
        return RouteConstants.kLogin;
      }

      // Authenticated: decide onboarding
      final shouldShowOnboarding = await ref.read(onboardingControllerProvider.future);
      if (shouldShowOnboarding) {
        return RouteConstants.kOnboarding;
      }

      // Preferences check (tri-state)
      final prefsStatus = await ref.read(preferencesControllerProvider.future);
      if (prefsStatus == PreferencesStatus.error) {
        // Proceed to preferences setup, UI can show a banner/toast about connectivity
        return RouteConstants.kSetPreferences;
      }
      if (prefsStatus == PreferencesStatus.notConfigured) {
        return RouteConstants.kSetPreferences;
      }

      // All good → go to app navigation (dashboard)
      return RouteConstants.kAppNavigation;
    } catch (_) {
      // On error, fallback to login to avoid blocking
      return RouteConstants.kLogin;
    }
  }
}

final splashControllerProvider = Provider.autoDispose<SplashController>(
  (ref) => SplashController(ref),
);
