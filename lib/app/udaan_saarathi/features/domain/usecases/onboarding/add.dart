import 'package:dartz/dartz.dart';
import '../../entities/Onboarding/entity.dart';
import '../../repositories/Onboarding/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddOnboardingUseCase implements UseCase<Unit, OnboardingEntity> {
  final OnboardingRepository repository;

  AddOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(OnboardingEntity entity) async {
    return  repository.addItem(entity);
  }
}
