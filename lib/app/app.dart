import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/udaan_saarathi/udaan_saarathi_app.dart';
import 'package:variant_dashboard/app/variant_dashboard/variant_dashboard_app.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // todo starts here : 
      // - profiver for app 
    return true? MaterialApp(home: UdaanSaarathiApp()) : VariantDashboard() ;
  }
}
