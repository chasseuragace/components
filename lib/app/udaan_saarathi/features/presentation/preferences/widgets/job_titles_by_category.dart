import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/job_title/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/models/job_title_models.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/job_title_chip.dart';

import '../../../data/models/job_title/model.dart';

class JobTitlesByCategory extends ConsumerWidget {
  const JobTitlesByCategory({
    super.key,
    this.availableJobTitles,
    required this.selectedJobTitles,
    required this.onAdd,
  });

  final List<JobTitle>? availableJobTitles;
  final List<JobTitleWithPriority> selectedJobTitles;
  final void Function(JobTitle) onAdd;

  @override
  Widget build(BuildContext context, ref) {
    final jobTitleState = ref.watch(getAllJobTitleProvider);
    if(availableJobTitles!=null) return body(availableJobTitles);
    return jobTitleState.when(
      data: (items) => items.isEmpty
          ? Center(child: Text('No items available'))
          : body(items),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  Column body(availableJobTitles) {
    final Map<String, List<JobTitle>> categorizedJobs = {};

    for (final job in availableJobTitles) {
      if (!job.isActive) continue;
      if (selectedJobTitles.any((selected) => selected.jobTitle.id == job.id)) {
        continue;
      }
      categorizedJobs.putIfAbsent(job.category, () => []).add(job);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categorizedJobs.entries.map((entry) {
        final String category = entry.key;
        final List<JobTitle> jobs = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: jobs
                        .map((job) =>
                            JobTitleChip(job: job, onTap: () => onAdd(job)))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }
}
