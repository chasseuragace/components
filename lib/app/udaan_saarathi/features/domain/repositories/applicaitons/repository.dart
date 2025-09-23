import 'package:dartz/dartz.dart';
import '../../entities/applicaitons/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class ApplicaitonsRepository {
  Future<Either<Failure, List<ApplicaitonsEntity>>> getAllItems();
  Future<Either<Failure, ApplicaitonsEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(ApplicaitonsEntity entity);
  Future<Either<Failure, Unit>> updateItem(ApplicaitonsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
  Future<Either<Failure, Unit>> applyJob(ApplicationEntity entity);
}
