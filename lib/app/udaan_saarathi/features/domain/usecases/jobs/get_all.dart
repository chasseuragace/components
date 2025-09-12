import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/jobs/entity.dart';
import '../../repositories/jobs/repository.dart';

class GetAllJobsUseCase implements UseCase<List<JobsEntity>, NoParm> {
  final JobsRepository repository;

  GetAllJobsUseCase(this.repository);

  @override
  Future<Either<Failure, List<JobsEntity>>> call(NoParm params) async {
    return repository.getAllItems();
  }
}
