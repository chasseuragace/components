import 'package:dartz/dartz.dart';
import '../../entities/Onboarding/entity.dart';
import '../../repositories/Onboarding/repository.dart';
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
