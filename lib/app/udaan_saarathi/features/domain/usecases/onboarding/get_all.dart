import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/onboarding/entity.dart';
import '../../repositories/onboarding/repository.dart';

class GetAllOnboardingUseCase
    implements UseCase<List<OnboardingEntity>, NoParm> {
  final OnboardingRepository repository;

  GetAllOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, List<OnboardingEntity>>> call(NoParm params) async {
    print("object aayo");
    return repository.getAllItems();
  }
}
