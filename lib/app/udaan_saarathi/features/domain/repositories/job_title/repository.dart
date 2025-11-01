import 'package:dartz/dartz.dart';
import '../../entities/job_title/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class JobTitleRepository {
  Future<Either<Failure, List<JobTitleEntity>>> getAllItems();
  Future<Either<Failure, JobTitleEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(JobTitleEntity entity);
  Future<Either<Failure, Unit>> updateItem(JobTitleEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
