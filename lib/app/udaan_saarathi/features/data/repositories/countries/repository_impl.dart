import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Countries/entity.dart';
import '../../../domain/repositories/Countries/repository.dart';
import '../../datasources/Countries/local_data_source.dart';
import '../../datasources/Countries/remote_data_source.dart';
import '../../models/Countries/model.dart';
class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesLocalDataSource localDataSource;
  final CountriesRemoteDataSource remoteDataSource;

  CountriesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<CountriesEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CountriesEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(CountriesEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as CountriesModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(CountriesEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as CountriesModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      await remoteDataSource.deleteItem(id);
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }
}
extension model on CountriesEntity {
  CountriesModel toModel() {
    throw UnimplementedError();
  }
}
