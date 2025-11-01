import 'package:dartz/dartz.dart';
import '../../entities/homepage/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class HomepageRepository {
  Future<Either<Failure, List<HomepageEntity>>> getAllItems();
  Future<Either<Failure, HomepageEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(HomepageEntity entity);
  Future<Either<Failure, Unit>> updateItem(HomepageEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
