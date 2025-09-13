import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/variant_dashboard/core/theme/app_theme.dart';
import 'package:variant_dashboard/variant_item.dart';

class VariantDashboard extends StatelessWidget {
  const VariantDashboard({
    super.key,
  });

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
