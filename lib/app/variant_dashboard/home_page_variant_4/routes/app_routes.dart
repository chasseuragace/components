import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String jobDashboard = '/job-dashboard-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const JobDashboardScreen(),
    jobDashboard: (context) => const JobDashboardScreen(),
    // TODO: Add your other routes here
  };
}
