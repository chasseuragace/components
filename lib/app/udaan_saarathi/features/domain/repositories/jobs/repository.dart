import 'package:dartz/dartz.dart';
import '../../entities/jobs/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class JobsRepository {
  Future<Either<Failure, List<JobsEntity>>> getAllItems();
  Future<Either<Failure, JobsEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(JobsEntity entity);
  Future<Either<Failure, Unit>> updateItem(JobsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
