import '../../../domain/entities/profile/entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({required super.skills, this.name});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      skills: json['skills'] as List<Map<String, dynamic>>?,
    );
  }

  final String? name;

  Map<String, dynamic> toJson() {
    return {
      'skills': skills,
    };
  }
}
