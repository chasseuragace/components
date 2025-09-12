import 'package:dartz/dartz.dart';
import '../../repositories/candidate/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteCandidateUseCase implements UseCase<Unit, String> {
  final CandidateRepository repository;

  DeleteCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
