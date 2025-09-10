import 'package:dartz/dartz.dart';
import '../../entities/search/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchEntity>>> getAllItems();
  Future<Either<Failure, SearchEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(SearchEntity entity);
  Future<Either<Failure, Unit>> updateItem(SearchEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
