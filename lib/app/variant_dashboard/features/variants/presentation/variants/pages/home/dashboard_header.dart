import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/candidate/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/utils.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/greetings.dart';

class DashboardHeader extends ConsumerWidget {
  // Changed to ConsumerWidget
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref

    final analytics = ref.watch(getCandidatAnalytocseByIdProvider);
    return analytics.when(
      data: (CandidateStatisticsEntity? data) {
        if (data == null) {
          return const SizedBox.shrink();
        }
        return body(data, context, ref);
      },
      error: (Object error, StackTrace stackTrace) {
        return const Center(child: Text('Failed to load analytics'));
      },
      loading: () {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Container body(CandidateStatisticsEntity analytics, BuildContext context,
      WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // colors: [AppColors.primaryColor, Color(0xFF6C5CE7)],
          colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kHorizontalMargin, vertical: kVerticalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Greetings(),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteConstants.kNotificationScreen);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: kHorizontalMargin / 2),
                  GestureDetector(
                    onTap: () {
                      ref.read(appHomeNavIndexProvider.notifier).state = 3;
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              // Quick Stats Row
              Row(
                children: [
                  _buildQuickStat(
                    'Applications',
                    analytics.total.toString(),
                    Icons.send_rounded,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteConstants.kApplicationsListScreen,
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildQuickStat(
                    'Shortlists',
                    analytics.byStatus.shortlisted.toString(),
                    Icons.list_alt,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteConstants.kApplicationsShortlistedTab,
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildQuickStat(
                    'Interviews',
                    analytics.byStatus.interviewScheduled.toString(),
                    Icons.event_rounded,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteConstants.kApplicationsInterviewTab,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon,
      {VoidCallback? onTap}) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Morning';
  if (hour < 17) return 'Afternoon';
  return 'Evening';
}
