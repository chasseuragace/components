import '../../../data/models/job_title/model.dart';
import '../../../presentation/preferences/models/job_title_models.dart';
import '../../base_entity.dart';

abstract class PreferencesEntity extends BaseEntity {
  final String id;
  PreferencesEntity({
    // TODO : Preferences : Define params
    required super.rawJson,
    required this.id,
  });
}



class JobTitleWithPriority {
  final JobTitle jobTitle;
  int priority;

  JobTitleWithPriority({required this.jobTitle, required this.priority});
}
