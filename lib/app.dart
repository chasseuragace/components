import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'features/variants/presentation/pages/variant_dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true, // Makes text adapt to screen
      splitScreenMode: true, // Useful for tablets/foldables
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UI Variants Showcase',
        theme: AppTheme.build(),
        home: VariantDashboardPage(),
      ),
    );
  }
}
