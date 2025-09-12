import 'package:dartz/dartz.dart';
import '../../entities/onboarding/entity.dart';
import '../../repositories/onboarding/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateOnboardingUseCase implements UseCase<Unit, OnboardingEntity> {
  final OnboardingRepository repository;

  UpdateOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(OnboardingEntity entity) async {
    return  repository.updateItem(entity);
  }
}
