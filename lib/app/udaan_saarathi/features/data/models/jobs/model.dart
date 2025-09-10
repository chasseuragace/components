import '../../../domain/entities/jobs/entity.dart';

class JobsModel extends JobsEntity {
  JobsModel({required super.id, this.name, required super.rawJson});

  factory JobsModel.fromJson(Map<String, dynamic> json) {
    return JobsModel(
      id: json['id'] as String,
        name: json['name'] as String?,
        rawJson: json, // Pass the entire JSON object
      );
  }
  
  final String? name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
