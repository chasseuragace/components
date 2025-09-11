import '../../../domain/entities/onboarding/entity.dart';

class OnboardingModel extends OnboardingEntity {
  OnboardingModel(
      {required super.id,
      this.name,
    
      required super.title,
      required super.description,
      required super.image,
      required super.primaryColor,
      required super.secondaryColor});



  final String? name;

 
}
