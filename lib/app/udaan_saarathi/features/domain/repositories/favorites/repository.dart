import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../entities/Favorites/entity.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoritesEntity>>> getAllItems();
  Future<Either<Failure, FavoritesEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem({required String jobId});
  Future<Either<Failure, Unit>> updateItem(FavoritesEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
