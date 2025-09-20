import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../candidate/providers/providers.dart';

class CandidateStats extends ConsumerWidget {
  const CandidateStats({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(getCandidatAnalytocseByIdProvider);

    return analytics.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, st) => Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Failed to load stats',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
        ),
      ),
      data: (stats) {
        if (stats == null) {
          return const SizedBox.shrink();
        }

        final items = <({String label, int value, Color color})>[
          (label: 'Total Candidates', value: stats.total, color: Colors.blue),
          (label: 'Active Candidates', value: stats.active, color: Colors.green),
          (label: 'Applied', value: stats.byStatus.applied, color: Colors.indigo),
          (label: 'Shortlisted', value: stats.byStatus.shortlisted, color: Colors.deepPurple),
          (label: 'Interview Scheduled', value: stats.byStatus.interviewScheduled, color: Colors.orange),
          (label: 'Interview Rescheduled', value: stats.byStatus.interviewRescheduled, color: Colors.teal),
          (label: 'Interview Passed', value: stats.byStatus.interviewPassed, color: Colors.lightGreen),
          (label: 'Interview Failed', value: stats.byStatus.interviewFailed, color: Colors.redAccent),
          (label: 'Withdrawn', value: stats.byStatus.withdrawn, color: Colors.brown),
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.1,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _StatCard(
                value: item.value.toString(),
                label: item.label,
                color: item.color,
              );
            },
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

