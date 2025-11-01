import 'package:dartz/dartz.dart';
import '../../entities/Agency/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class AgencyRepository {
  Future<Either<Failure, List<AgencyEntity>>> getAllItems();
  Future<Either<Failure, AgencyEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(AgencyEntity entity);
  Future<Either<Failure, Unit>> updateItem(AgencyEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
