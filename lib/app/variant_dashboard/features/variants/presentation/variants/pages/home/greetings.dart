import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart' as cand;
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';

class Greetings extends ConsumerWidget {
  const Greetings({
    super.key,
    required this.analytics,
  });


  final DashboardAnalytics analytics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candState = ref.watch(cand.getCandidateByIdProvider);
    final name = candState.when(
      data: (c) => (c?.fullName?.trim().isNotEmpty == true) ? c!.fullName! : 'Guest',
      loading: () => '...',
      error: (_, __) => 'Guest',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good ${getGreeting()},',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          '${analytics.recommendedJobsCount} jobs match your profile',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
