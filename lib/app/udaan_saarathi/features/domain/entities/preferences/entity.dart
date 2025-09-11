import '../../base_entity.dart';

abstract class PreferencesEntity extends BaseEntity {
  final String id;
  PreferencesEntity({
    // TODO : Preferences : Define params
    required super.rawJson,
    required this.id,
  });
}

// Data Models
class JobTitle {
  final int id;
  final String title;
  final String category;
  final bool isActive;

  JobTitle({
    required this.id,
    required this.title,
    required this.category,
    required this.isActive,
  });
}

class JobTitleWithPriority {
  final JobTitle jobTitle;
  int priority;

  JobTitleWithPriority({required this.jobTitle, required this.priority});
}
