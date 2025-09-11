import 'package:dartz/dartz.dart';
import '../../entities/onboarding/entity.dart';
import '../../repositories/onboarding/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllOnboardingUseCase implements UseCase<List<OnboardingEntity>, NoParm> {
  final OnboardingRepository repository;

  GetAllOnboardingUseCase (this.repository);

  @override
  Future<Either<Failure, List<OnboardingEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
