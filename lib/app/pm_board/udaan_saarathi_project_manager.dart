import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/pm_board/wrapper_widget.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/page/application_detail_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/homepage/page/home_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/interviews/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/set_preferences_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/profile_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/splash/page/splash_screen.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/pages/variant_dashboard_page.dart';

import '../udaan_saarathi/features/presentation/applicaitons/page/list.dart';
import '../udaan_saarathi/features/presentation/auth/pages/login_page.dart';
import '../udaan_saarathi/features/presentation/auth/pages/register_page.dart';
import '../udaan_saarathi/features/presentation/job_detail/page/job_details_page.dart';
import '../variant_dashboard/features/variants/domain/entities/variant_item.dart';
import '../variant_dashboard/features/variants/presentation/widgets/variant_preview.dart'
    show VariantPreview;

var width2 = 375.0;
final expansionStateProvider = StateProvider<bool>((ref) => false);

/// KeepAlive helper to preserve widget state in scrollable views like PageView
class KeepAlive extends StatefulWidget {
  const KeepAlive({super.key, required this.child});

  final Widget child;

  @override
  State<KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class UdaanSaarathiProjectManager extends StatelessWidget {
  const UdaanSaarathiProjectManager({super.key});

  @override
  Widget build(BuildContext context) {
    var width3 = MediaQuery.of(context).size.width;
    var height2 = MediaQuery.of(context).size.height;
    var other = 1;
    return WrapperWidget(
        width3: width3, height2: height2, other: other, child: pageView());
  }

  PageView pageView() {
    return PageView(
      controller: PageController(viewportFraction: .3),
      children: [
        buildScreen(ApplicaitonsListPage()),
        buildScreen(ApplicationDetailsPage()),
        if (true) ...[
          buildScreen(const JobsListPage()),
          buildScreen(InterviewsListPage()),
          buildScreen(const ProfilePage()),
          buildScreen(const SplashScreen()),
          buildScreen(const OnboardingListPage()),
          PageView(
            controller: PageController(viewportFraction: .9),
            clipBehavior: Clip.none,
            padEnds: false,
            scrollDirection: Axis.vertical,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildScreen(const RegisterPage(), wideMultifiler: 1),
              buildScreen(const LoginPage()),
            ]
                .map((e) => Expanded(child: FittedBox(child: e)))
                .map((e) => KeepAlive(child: e))
                .toList(),
          ),
          buildScreen(const SetPreferenceScreen()),
          buildScreen(const HomePage()),
          // buildScreen(JobDetailPage(job: blueCollarJobQatar)),
        ]
      ].map((e) => KeepAlive(child: e)).toList(),
    );
  }

  Widget buildScreen(Widget udaanSaarathiApp, {int wideMultifiler = 1}) {
    return Padding(
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
