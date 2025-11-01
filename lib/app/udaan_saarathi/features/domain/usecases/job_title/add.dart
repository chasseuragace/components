import 'package:dartz/dartz.dart';
import '../../entities/job_title/entity.dart';
import '../../repositories/job_title/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddJobTitleUseCase implements UseCase<Unit, JobTitleEntity> {
  final JobTitleRepository repository;

  AddJobTitleUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(JobTitleEntity entity) async {
    return  repository.addItem(entity);
  }
}
