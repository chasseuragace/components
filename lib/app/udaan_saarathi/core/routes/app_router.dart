import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/notifications/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/login_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/otp_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/register_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/interviews/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/job_detail/page/job_details_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/notification_detail/notification_detail_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/set_preferences_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/education_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/experience_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/personal_info_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/profile_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/skills_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/trainings_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/settings/page/settings_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/splash/page/splash_screen.dart';

final class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.kSplashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouteConstants.kLogin:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case RouteConstants.kSignup:
        return MaterialPageRoute(builder: (context) => const RegisterPage());
      case RouteConstants.kOnboarding:
        return MaterialPageRoute(
            builder: (context) => const OnboardingListPage());
      case RouteConstants.kAppNavigation:
        return MaterialPageRoute(
            builder: (context) => const AppHomeNavigationPage());
      case RouteConstants.kSetPreferences:
        return MaterialPageRoute(
            builder: (context) => const SetPreferenceScreen());
      case RouteConstants.kApplicationsListScreen:
        return MaterialPageRoute(
            builder: (context) => const ApplicaitonsListPage());
      case RouteConstants.kNotificationDetailScreen:
        final args = settings.arguments as JobNotificationEntity;
        return MaterialPageRoute(
            builder: (context) => NotificationDetailPage(
                  notification: args,
                ));
      case RouteConstants.kProfileScreen:
        return MaterialPageRoute(builder: (context) => const ProfilePage());
      case RouteConstants.kPersonalInfoScreen:
        return MaterialPageRoute(
            builder: (context) => const PersonalInfoFormPage());
      case RouteConstants.kWorkExperienceScreen:
        return MaterialPageRoute(
            builder: (context) => const WorkExperienceFormPage());
      case RouteConstants.kEducationScreen:
        return MaterialPageRoute(
            builder: (context) => const EducationFormPage());
      case RouteConstants.kTrainingScreen:
        return MaterialPageRoute(
            builder: (context) => const TrainingsFormPage());
      case RouteConstants.kSkillsScreen:
        return MaterialPageRoute(builder: (context) => const SkillsFormPage());
      case RouteConstants.kSettingsScreen:
        return MaterialPageRoute(builder: (context) => const SettingsPage());
      case RouteConstants.kInterviewListScreen:
        return MaterialPageRoute(
            builder: (context) => const InterviewsListPage());
      case RouteConstants.kJobDetailScreen:
        final args = settings.arguments as MobileJobEntity;
        return MaterialPageRoute(
            builder: (context) => JobDetailPage(
                  job: args,
                ));
      case RouteConstants.kOtpScreen:
        final args = settings.arguments as List;
        return MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
                  phoneNumber: args[0] as String,
                  isLogin: args[1] as bool,
                  devOtp: args[2] as String,
                  fullName: args[3] as String?,
                ));
      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}
