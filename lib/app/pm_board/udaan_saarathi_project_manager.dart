import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/pm_board/pm_board_app.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/set_preferences_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/splash/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/splash/page/splash_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/udaan_saarathi_app.dart';
import 'package:variant_dashboard/app/variant_dashboard/core/theme/app_theme.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';

import '../variant_dashboard/features/variants/domain/entities/variant_item.dart';
import '../variant_dashboard/features/variants/presentation/widgets/variant_preview.dart'
    show VariantPreview;
final expansionStateProvider = StateProvider<bool>((ref)=>false);
class UdaanSaarathiProjectManager extends StatelessWidget {
  const UdaanSaarathiProjectManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSize(duration: Duration(milliseconds: 200),
                  child:  Row(
          children: [
            Consumer  (
              child: PMBoardApp(),
              builder: (context,ref,child) {
                return AnimatedContainer(width: (ref.watch(expansionStateProvider)?3:2.5)*300,duration: Duration(seconds: 1 ),
                child: GestureDetector(
                  onDoubleTap: (){
                    ref.read(expansionStateProvider.notifier).update((_)=>!_);
                  },
                  child: child!),
                );
              }
            ),
            // mobile screen for udaansaarathi app
            // can set builder here
            // eg: shows using one of the hte existing variant page in use
            Expanded(
              child: Row(
                children: [
                  buildScreen(const SplashScreen()),
                  buildScreen(const OnboardingListPage()),
                  buildScreen(const SetPreferenceScreen()),
                  buildScreen(const HomePageVariant1  ()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildScreen(udaanSaarathiApp) {
  
                    
    return Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 8.0),
                child: Center(
                  child: ScreenUtilInit(
                    designSize: const Size(375, 812),
                    minTextAdapt: true, // Makes text adapt to screen
                    splitScreenMode: true, // Useful for tablets/foldables
                    builder: (context, child) => SizedBox(
                    width: 375,
                    height: 812,
                    child:  FittedBox(
                      child: VariantPreview(
                            variant: VariantItem(
                              name: 'Auth - Login (Minimal)',
                              builder: (BuildContext context) {
                                return udaanSaarathiApp;
                              },
                            ),
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
