import 'package:dartz/dartz.dart';
import '../../entities/job_title/entity.dart';
import '../../repositories/job_title/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateJobTitleUseCase implements UseCase<Unit, JobTitleEntity> {
  final JobTitleRepository repository;

  UpdateJobTitleUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(JobTitleEntity entity) async {
    return  repository.updateItem(entity);
  }
}
