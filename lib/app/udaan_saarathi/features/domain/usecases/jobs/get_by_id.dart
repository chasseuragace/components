import 'package:dartz/dartz.dart';
import '../../entities/jobs/entity.dart';
import '../../repositories/jobs/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetJobsByIdUseCase implements UseCase<JobsEntity?, String> {
  final JobsRepository repository;

  GetJobsByIdUseCase(this.repository);

  @override
  Future<Either<Failure, JobsEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
