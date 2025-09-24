import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/candidate/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/interviews/page/list.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/greetings.dart';

class DashboardHeader extends ConsumerWidget {
  // Changed to ConsumerWidget
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref

    final analytics = ref.watch(getCandidatAnalytocseByIdProvider);
    return analytics.when(data: (CandidateStatisticsEntity? data) {
      return body(data!, context);
    }, error: (Object error, StackTrace stackTrace) {
      return SizedBox();
    }, loading: () {
      return SizedBox();
    });
  }

  Container body(CandidateStatisticsEntity analytics, BuildContext context) {
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Greetings(),
                  ),
                  Container(
                    width: 60,
                    height: 60,
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
                ],
              ),
              const SizedBox(height: 24.0),
              // Quick Stats Row
              Row(
                children: [
                  _buildQuickStat(
                    'Applications',
                    analytics.byStatus.applied.toString(),
                    Icons.send_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  _buildQuickStat(
                    'Shortlists',
                    analytics.byStatus.shortlisted.toString(),
                    Icons.list_alt,
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  _buildQuickStat(
                    'Interviews',
                    analytics.byStatus.interviewScheduled.toString(),
                    Icons.event_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InterviewsListPage(),
                        ),
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
        padding: EdgeInsets.all(16),
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
