
import '../../base_entity.dart';

abstract class OnboardingEntity extends BaseEntity {
  final String id;
  OnboardingEntity({
        // TODO : Onboarding : Define params
        required super.rawJson,
        required this.id,
        });
}
