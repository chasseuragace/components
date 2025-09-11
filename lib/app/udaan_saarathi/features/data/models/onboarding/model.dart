import '../../../domain/entities/Onboarding/entity.dart';

class OnboardingModel extends OnboardingEntity {
  OnboardingModel({required super.id, this.name, required super.rawJson});

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
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
