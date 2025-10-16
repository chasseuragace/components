import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/app_router.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/theme/theme.dart';

class UdaanSaarathiApp extends StatelessWidget {
  const UdaanSaarathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.build(),
        initialRoute: RouteConstants.kSplashScreen,
        onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
      ),
    );
  }
}
