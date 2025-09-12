import 'package:dartz/dartz.dart';
import '../../entities/job_title/entity.dart';
import '../../repositories/job_title/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllJobTitleUseCase implements UseCase<List<JobTitleEntity>, NoParm> {
  final JobTitleRepository repository;

  GetAllJobTitleUseCase (this.repository);

  @override
  Future<Either<Failure, List<JobTitleEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
