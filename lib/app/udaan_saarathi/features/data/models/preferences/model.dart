import '../../../domain/entities/preferences/entity.dart';

class PreferencesModel extends PreferencesEntity {
  PreferencesModel({
    required super.id,
    required super.jobTitleId,

    required super.rawJson,
    required super.title,
    required super.priority,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      id: json['id'] as String,
      jobTitleId: json['job_title_id'] as String,
    
      rawJson: json, // Pass the entire JSON object
      title: json['title'] as String,
      priority: json['priority'] as int,
    );
  }
  


  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'job_title_id': jobTitleId,
      'title': title,
      'priority': priority,
    };
  }
}
