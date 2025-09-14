import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/app_router.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';

class UdaanSaarathiApp extends StatelessWidget {
  const UdaanSaarathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteConstants.kSplashScreen,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
