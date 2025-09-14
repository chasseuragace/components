import 'package:dartz/dartz.dart';
import '../../entities/Countries/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class CountriesRepository {
  Future<Either<Failure, List<CountriesEntity>>> getAllItems();
  Future<Either<Failure, CountriesEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(CountriesEntity entity);
  Future<Either<Failure, Unit>> updateItem(CountriesEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
