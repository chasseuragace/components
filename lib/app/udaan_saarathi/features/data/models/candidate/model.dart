import '../../../domain/entities/candidate/entity.dart';

class CandidateModel extends CandidateEntity {
  CandidateModel({required super.id, this.name, required super.rawJson});

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
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
