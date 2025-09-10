import '../../../domain/entities/applicaitons/entity.dart';

class ApplicaitonsModel extends ApplicaitonsEntity {
  ApplicaitonsModel({required super.id, this.name, required super.rawJson});

  factory ApplicaitonsModel.fromJson(Map<String, dynamic> json) {
    return ApplicaitonsModel(
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
