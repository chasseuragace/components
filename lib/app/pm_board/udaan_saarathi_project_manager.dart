import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/pm_board/pm_board_app.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/login_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/udaan_saarathi_app.dart';
import 'package:variant_dashboard/app/variant_dashboard/core/theme/app_theme.dart';

import '../variant_dashboard/features/variants/domain/entities/variant_item.dart';
import '../variant_dashboard/features/variants/presentation/widgets/variant_preview.dart'
    show VariantPreview;

class UdaanSaarathiProjectManager extends StatelessWidget {
  const UdaanSaarathiProjectManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 3, child: PMBoardApp()),
          // mobile screen for udaansaarathi app
          // can set builder here
          // eg: shows using one of the hte existing variant page in use
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 80),
              child: ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true, // Makes text adapt to screen
                splitScreenMode: true, // Useful for tablets/foldables
                builder: (context, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'UI Variants Showcase',
                  theme: AppTheme.build(),
                  home: VariantPreview(
                    variant: VariantItem(
                      name: 'Auth - Login (Minimal)',
                      builder: (BuildContext context) => const UdaanSaarathiApp(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
