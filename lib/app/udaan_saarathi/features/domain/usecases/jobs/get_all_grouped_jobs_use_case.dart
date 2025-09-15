import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/errors/failures.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/usecases/usecase.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/jobs/repository.dart';

class GetAllGroupedJobsUseCase implements UseCase<GroupedJobsEntity, NoParm> {
  final JobsRepository repository;

  GetAllGroupedJobsUseCase(this.repository);

  @override
  Future<Either<Failure, GroupedJobsEntity>> call(NoParm params) async {
    return repository.getGroupedJobs();
  }
}
