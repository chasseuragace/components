import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/providers/onboarding_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';

class SplashController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  
  SplashController(this.ref) : super(const AsyncValue.data(null));

  /// Determine the next route to navigate to based on app state
  Future<String> determineRoute() async {
    state = const AsyncValue.loading();
    try {
      // Ensure auth state is up to date
      await ref.read(authControllerProvider.notifier).checkAuthOnLaunch();
      final authState = ref.read(authControllerProvider);

      if (!authState.isAuthenticated) {
        state = const AsyncValue.data(null);
        return RouteConstants.kLogin;
      }

      // Authenticated: decide onboarding
      final shouldShowOnboarding = await ref.read(onboardingControllerProvider.future);
      if (shouldShowOnboarding) {
        state = const AsyncValue.data(null);
        return RouteConstants.kOnboarding;
      }

      // TODO: Check preferences once implemented
      // final hasConfiguredPreferences = await _checkPreferences();
      // if (!hasConfiguredPreferences) {
      //   state = const AsyncValue.data(null);
      //   return RouteConstants.kSetPreferences;
      // }

      // All good → go to app navigation (dashboard)
      state = const AsyncValue.data(null);
      return RouteConstants.kAppNavigation;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      // On error, fallback to login to avoid blocking
      return RouteConstants.kLogin;
    }
  }
}

final splashControllerProvider = StateNotifierProvider.autoDispose<SplashController, AsyncValue<void>>(
  (ref) => SplashController(ref),
);
