import '../../../domain/entities/splash/entity.dart';

class SplashModel extends SplashEntity {
  SplashModel({required super.id, this.name, required super.rawJson});

  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
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
