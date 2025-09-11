import 'package:dartz/dartz.dart';
import '../../entities/Onboarding/entity.dart';
import '../../repositories/Onboarding/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetOnboardingByIdUseCase implements UseCase<OnboardingEntity?, String> {
  final OnboardingRepository repository;

  GetOnboardingByIdUseCase(this.repository);

  @override
  Future<Either<Failure, OnboardingEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
