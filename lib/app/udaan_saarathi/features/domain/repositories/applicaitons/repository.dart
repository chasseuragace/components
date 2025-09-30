import 'package:dartz/dartz.dart';
import '../../entities/applicaitons/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class ApplicaitonsRepository {
  Future<Either<Failure, ApplicationPaginationWrapper>> getAllItems();
  Future<Either<Failure, ApplicationDetailsEntity>> getItemById(String id);

  Future<Either<Failure, Unit>> updateItem(ApplicaitonsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
  Future<Either<Failure, Unit>> applyJob(ApplyJobDTOEntity entity);
}
