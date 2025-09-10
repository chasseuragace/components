import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/pm_board/udaan_saarathi_project_manager.dart';
import 'package:variant_dashboard/app/udaan_saarathi/udaan_saarathi_app.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/pages/variant_dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // todo starts here :
    // - profiver for app
    return true
        ? UdaanSaarathiProjectManager()
        : true
        ? UdaanSaarathiApp()
        : VariantDashboardPage();
  }
}
