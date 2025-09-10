import '../../../domain/entities/profile/entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({required super.id, this.name, required super.rawJson});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
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
