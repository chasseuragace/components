import 'package:dartz/dartz.dart';
import '../../entities/splash/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class SplashRepository {
  Future<Either<Failure, List<SplashEntity>>> getAllItems();
  Future<Either<Failure, SplashEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(SplashEntity entity);
  Future<Either<Failure, Unit>> updateItem(SplashEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
