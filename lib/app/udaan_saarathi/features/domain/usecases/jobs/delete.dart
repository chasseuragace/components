import 'package:dartz/dartz.dart';
import '../../repositories/jobs/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteJobsUseCase implements UseCase<Unit, String> {
  final JobsRepository repository;

  DeleteJobsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
