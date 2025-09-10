import 'package:dartz/dartz.dart';
import '../../entities/jobs/entity.dart';
import '../../repositories/jobs/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateJobsUseCase implements UseCase<Unit, JobsEntity> {
  final JobsRepository repository;

  UpdateJobsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(JobsEntity entity) async {
    return  repository.updateItem(entity);
  }
}
