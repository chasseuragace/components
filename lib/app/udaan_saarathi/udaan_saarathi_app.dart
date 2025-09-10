import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/pm_board/udaan_saarathi_project_manager.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';

class UdaanSaarathiApp extends StatelessWidget {
  const UdaanSaarathiApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePageVariant1());
  }
}
