// class JobTitle {
//   final int id;
//   final String title;
//   final String category;
//   final bool isActive;

//   JobTitle({
//     required this.id,
//     required this.title,
//     required this.category,
//     required this.isActive,
//   });
// }

import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/job_title/model.dart';

class JobTitleWithPriority {
  final JobTitle jobTitle;
  int priority;

  JobTitleWithPriority({
    required this.jobTitle,
    required this.priority,
  });
}
