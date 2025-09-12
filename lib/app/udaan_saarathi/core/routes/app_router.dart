import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/onboarding_screen_1.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/set_preferences_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/splash/page/splash_screen.dart';

final class AppRouter {
  static Route? generateRoute(WidgetRef ref, RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.kSplashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouteConstants.kOnboarding:
        return MaterialPageRoute(
            builder: (context) => const OnboardingScreen1());
      case RouteConstants.kAppNavigation:
        return MaterialPageRoute(
            builder: (context) => const AppHomeNavigationPage());
      case RouteConstants.kSetPreferences:
        return MaterialPageRoute(
            builder: (context) => const SetPreferenceScreen());
    }
    return null;
  }
}
