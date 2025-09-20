import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/candidate/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/greetings.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/provider/home_screen_provider.dart';

class DashboardHeader extends ConsumerWidget {
  // Changed to ConsumerWidget
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref

    final analytics =ref.watch(getCandidatAnalytocseByIdProvider);
    return analytics.when(data: (CandidateStatisticsEntity? data) { return  body(data!); }, error: (Object error, StackTrace stackTrace) { 
      return SizedBox();
     }, loading: () { 
      return SizedBox();
      });
   
  }

  Container body(CandidateStatisticsEntity analytics) {
    return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4F7DF9), Color(0xFF6C5CE7)],
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
                  child:
                      Greetings(),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
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
                ),
                const SizedBox(width: 16),
                _buildQuickStat(
                  'Shortlists',
                  analytics.byStatus.shortlisted.toString(),
                  Icons.list_alt,
                ),
                const SizedBox(width: 16),
                _buildQuickStat(
                  'Interviews',
                  analytics.byStatus.interviewScheduled.toString(),
                  Icons.event_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Morning';
  if (hour < 17) return 'Afternoon';
  return 'Evening';
}
