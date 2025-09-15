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

import '../udaan_saarathi/features/presentation/auth/pages/login_page.dart';
import '../udaan_saarathi/features/presentation/auth/pages/register_page.dart';
import '../variant_dashboard/features/variants/domain/entities/variant_item.dart';
import '../variant_dashboard/features/variants/presentation/widgets/variant_preview.dart'
    show VariantPreview;
    var width2 = 375.0;
final expansionStateProvider = StateProvider<bool>((ref) => false);

class UdaanSaarathiProjectManager extends StatelessWidget {
  const UdaanSaarathiProjectManager({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnimatedSize(
        duration: Duration(milliseconds: 200),
        child: Row(
          children: [
            Consumer(
                child: PMBoardApp(),
                builder: (context, ref, child) {
                  return AnimatedContainer(
                    width: (ref.watch(expansionStateProvider) ? 3 : 0) * 300,
                    duration: Duration(seconds: 1),
                    child: GestureDetector(
                        onDoubleTap: () {
                          ref
                              .read(expansionStateProvider.notifier)
                              .update((_) => !_);
                        },
                        child: child!),
                  );
                }),
            // mobile screen for udaansaarathi app
            // can set builder here
            // eg: shows using one of the hte existing variant page in use

            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 3,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    buildScreen(const SplashScreen()),
                      buildScreen(const OnboardingListPage()),
                      SizedBox(
                        width: width2,
                        child: PageView(
                          controller: PageController(viewportFraction: .79),
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.vertical,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildScreen(const RegisterPage(),wideMultifiler:1),
                            buildScreen(const LoginPage()),
                          ]
                              .map((e) => Expanded(child: FittedBox(child: e)))
                              .toList(),
                        ),
                      ),
                      buildScreen(const SetPreferenceScreen()),
                      buildScreen(const HomePageVariant1()),
                    ].map((e) => e).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScreen(udaanSaarathiApp, { int wideMultifiler=1}) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Center(
        child: ScreenUtilInit(
          designSize: const Size(375, 812.0),
          minTextAdapt: true, // Makes text adapt to screen
          splitScreenMode: true, // Useful for tablets/foldables
          builder: (context, child) => SizedBox(
            width: width2,
            height: 812,
            child: FittedBox(
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
    );
  }
}
