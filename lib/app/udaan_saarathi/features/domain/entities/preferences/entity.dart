import '../../base_entity.dart';

abstract class PreferencesEntity extends BaseEntity {
  final String id;
  final String jobTitleId;
  final String title;
  final int priority;
  PreferencesEntity({
    // TODO : Preferences : Define params
    required super.rawJson,
    required this.id,
    required this.jobTitleId,
    required this.title,
    required this.priority,
  });
}



