import 'package:dartz/dartz.dart';
import '../../entities/Onboarding/entity.dart';
import '../../repositories/Onboarding/repository.dart';
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
