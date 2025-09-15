import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';
import '../../entities/jobs/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class JobsRepository {
  Future<Either<Failure, List<JobsEntity>>> getAllItems();
  Future<Either<Failure, JobsEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(JobsEntity entity);
  Future<Either<Failure, Unit>> updateItem(JobsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
  /// new method to 
    Future<Either<Failure, GroupedJobsEntity>> getGroupedJobs();
}
