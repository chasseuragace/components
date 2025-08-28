import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/variants/presentation/pages/variant_dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Variants Showcase',
      theme: AppTheme.build(),
      home: VariantDashboardPage(),
    );
  }
}
