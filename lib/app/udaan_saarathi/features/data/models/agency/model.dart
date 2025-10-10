import '../../../domain/entities/Agency/entity.dart';

class AgencyModel extends AgencyEntity {
  AgencyModel({required super.id, this.name, required super.rawJson});

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
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
