import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/login_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/candidate_stats.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/pages.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/profile_cards_group.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/profile_content_widget.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/settings/user_settings_1.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
     
      body: SingleChildScrollView(
        child: Column(
          children: [
           
            // Header Section with Profile Image and Basic Info
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                   SizedBox(height: kToolbarHeight,),
                  ProfileContentWidget(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Job Statistics Cards
            CandidateStats(),

            // const SizedBox(height: 32),
            _buildActivityChart(),
            // Profile Menu Items
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ProfileCardsGroup(),
            ),

            const SizedBox(height: 32),

            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChart() {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Applications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Weekly Activity',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFFFD60A).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF8500),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Simple Bar Chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBarItem('Mon', 25),
              _buildBarItem('Tue', 40),
              _buildBarItem('Wed', 30),
              _buildBarItem('Thu', 35),
              _buildBarItem('Fri', 45),
              _buildBarItem('Sat', 20),
              _buildBarItem('Sun', 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(String day, double height) {
    return Column(
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: day == 'Fri' ? Color(0xFFFF6B35) : Color(0xFFFFD60A),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 10, color: Color(0xFF8E8E93))),
      ],
    );
  }
}
