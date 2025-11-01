import 'package:dartz/dartz.dart';
import '../../entities/job_title/entity.dart';
import '../../repositories/job_title/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetJobTitleByIdUseCase implements UseCase<JobTitleEntity?, String> {
  final JobTitleRepository repository;

  GetJobTitleByIdUseCase(this.repository);

  @override
  Future<Either<Failure, JobTitleEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
