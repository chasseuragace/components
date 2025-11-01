import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/gameplay/homepage.dart';
import 'package:variant_dashboard/app/pm_board/udaan_saarathi_project_manager.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/paginated_job_listings_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/udaan_saarathi_app.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/pages/variant_dashboard_page.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // todo starts here :
    // - profiver for app
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: 
       
        !true
            ? Homepage()
            : false
                ? Opacity(opacity: 1, child: UdaanSaarathiProjectManager())
                : true
                    ? UdaanSaarathiApp()
                    : VariantDashboardPage(),
        // initialRoute: RouteConstants.kSplashScreen,
        // onGenerateRoute: (settings) => AppRouter.generateRoute(ref, settings),
      ),
    );
  }
}
