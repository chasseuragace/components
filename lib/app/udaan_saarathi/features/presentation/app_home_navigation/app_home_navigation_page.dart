import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/agency/page/agency_listing_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/homepage/page/home_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/profile_screen.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_dialog.dart';

class AppHomeNavigationPage extends ConsumerWidget {
  const AppHomeNavigationPage({super.key});

  static final _pages = <Widget>[
    const HomePage(),
    JobsListPage(),
    const AgencyListingScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appHomeNavIndexProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        final index = ref.read(appHomeNavIndexProvider);
        if (index == 0) {
          CustomDialog.showCustomDialog(
            context,
            title: 'Exit App?',
            subtitle: 'Are you sure you want to close the app?',
            negativeText: 'No',
            positiveText: 'Yes',
            onTap: () {
              SystemNavigator.pop();
            },
            barrierDismissible: true,
          );
        } else {
          ref.read(appHomeNavIndexProvider.notifier).state = 0;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          onTap: (index) =>
              ref.read(appHomeNavIndexProvider.notifier).state = index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                activeIcon: Icon(Icons.work),
                label: 'Jobs'),
            BottomNavigationBarItem(
                icon: Icon(Icons.apartment_outlined),
                activeIcon: Icon(Icons.apartment),
                label: 'Agency'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
