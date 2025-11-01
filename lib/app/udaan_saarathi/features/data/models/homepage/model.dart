import '../../../domain/entities/homepage/entity.dart';

class HomepageModel extends HomepageEntity {
  HomepageModel({required super.id, this.name, required super.rawJson});

  factory HomepageModel.fromJson(Map<String, dynamic> json) {
    return HomepageModel(
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
