import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/list.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/agency_listings/agency_listing_screen_1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/profile/profile_screen_2.dart';

class AppHomeNavigationPage extends ConsumerWidget {
  const AppHomeNavigationPage({super.key});

  static final _pages = <Widget>[
    const HomePageVariant1(),
    JobsListPage(),
    const AgencyListingScreen1(),
    const ProfileScreen2(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appHomeNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
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
    );
  }
}
