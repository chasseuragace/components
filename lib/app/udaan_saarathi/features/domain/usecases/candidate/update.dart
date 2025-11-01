import 'package:dartz/dartz.dart';
import '../../entities/candidate/entity.dart';
import '../../repositories/candidate/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateCandidateUseCase implements UseCase<Unit, CandidateEntity> {
  final CandidateRepository repository;

  UpdateCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CandidateEntity entity) async {
    return  repository.updateItem(entity);
  }
}
