import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/preferences/entity.dart';

import '../../../data/models/job_title/model.dart';
import '../models/job_title_models.dart';
import 'job_title_chip.dart'; // The chip class we created earlier
import 'selected_job_title_card.dart'; // The class we created earlier
import 'step_header.dart'; // Your custom step header widget

class JobTitlesStep extends StatelessWidget {
  final List<JobTitleWithPriority> selectedJobTitles;
  final List<JobTitle> availableJobTitles;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(JobTitleWithPriority jobTitle) onRemove;
  final void Function(JobTitle job) onAdd;

  const JobTitlesStep({
    super.key,
    required this.selectedJobTitles,
    required this.availableJobTitles,
    required this.onReorder,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Choose Your Preferred Job Titles',
            subtitle:
                'Select and prioritize job titles. Your top choice appears first.',
            icon: Icons.work_outline,
            color: const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 24),

          // Selected Job Titles (Priority Order)
          if (selectedJobTitles.isNotEmpty) ...[
            const Text(
              'Your Preferences (Priority Order)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Container(
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
              child: ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: onReorder,
                children: selectedJobTitles.asMap().entries.map((entry) {
                  int index = entry.key;
                  JobTitleWithPriority jobTitle = entry.value;

                  return SelectedJobTitleCard(
                    key: ValueKey(jobTitle.jobTitle.id),
                    item: jobTitle,
                    index: index,
                    onRemove: () => onRemove(jobTitle),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Available Job Titles by Category
          const Text(
            'Available Job Titles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),

          ..._buildJobTitlesByCategory(),
        ],
      ),
    );
  }

  List<Widget> _buildJobTitlesByCategory() {
    Map<String, List<JobTitle>> categorizedJobs = {};

    for (JobTitle job in availableJobTitles) {
      if (!job.isActive) continue;
      if (selectedJobTitles.any((selected) => selected.jobTitle.id == job.id)) {
        continue;
      }

      categorizedJobs.putIfAbsent(job.category, () => []);
      categorizedJobs[job.category]!.add(job);
    }

    return categorizedJobs.entries.map((entry) {
      String category = entry.key;
      List<JobTitle> jobs = entry.value;

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
                      .map((job) => JobTitleChip(
                            job: job,
                            onTap: () => onAdd(job),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  // List<Widget> _buildJobTitlesByCategory() {
  //   Map<String, List<JobTitle>> categorizedJobs = {};

  //   for (JobTitle job in availableJobTitles) {
  //     if (!job.isActive) continue;
  //     if (selectedJobTitles.any((selected) => selected.jobTitle.id == job.id))
  //       continue;

  //     if (!categorizedJobs.containsKey(job.category)) {
  //       categorizedJobs[job.category] = [];
  //     }
  //     categorizedJobs[job.category]!.add(job);
  //   }

  //   return categorizedJobs.entries.map((entry) {
  //     String category = entry.key;
  //     List<JobTitle> jobs = entry.value;

  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(bottom: 12),
  //           padding: EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.05),
  //                 blurRadius: 10,
  //                 offset: Offset(0, 2),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 category,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w600,
  //                   color: Color(0xFF475569),
  //                 ),
  //               ),
  //               SizedBox(height: 12),
  //               Wrap(
  //                 spacing: 8,
  //                 runSpacing: 8,
  //                 children: jobs
  //                     .map((job) => JobTitleChip(
  //                         job: job, onTap: () => onAdd(job)))
  //                     .toList(),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 16),
  //       ],
  //     );
  //   }).toList();
  // }
}
