import 'package:dartz/dartz.dart';
import '../../repositories/Onboarding/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteOnboardingUseCase implements UseCase<Unit, String> {
  final OnboardingRepository repository;

  DeleteOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
