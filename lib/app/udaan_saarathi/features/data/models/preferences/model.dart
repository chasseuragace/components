import '../../../domain/entities/preferences/entity.dart';

class PreferencesModel extends PreferencesEntity {
  PreferencesModel({
    required super.id,
    required super.jobTitleId,
    this.name,
    required super.rawJson,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      id: json['id'] as String,
      jobTitleId: json['job_title_id'] as String,
      name: json['name'] as String?,
      rawJson: json, // Pass the entire JSON object
    );
  }
  
  final String? name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'job_title_id': jobTitleId,
    };
  }
}
