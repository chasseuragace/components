import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Countries/entity.dart';
import '../../../domain/repositories/Countries/repository.dart';
import '../../datasources/Countries/local_data_source.dart';
import '../../datasources/Countries/remote_data_source.dart';
import '../../models/Countries/model.dart';
// Fake data for Countriess
      final remoteItems = [
        CountriesModel(

            rawJson: {},
          id: '1',
          name: 'Admin',
        ),
        CountriesModel(
        rawJson: {},
          id: '2',
          name: 'User',
        ),
        CountriesModel(
        rawJson: {},
          id: '3',
          name: 'Guest',
        ),
      ];
class CountriesRepositoryFake implements CountriesRepository {
  final CountriesLocalDataSource localDataSource;
  final CountriesRemoteDataSource remoteDataSource;

  CountriesRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<CountriesEntity>>> getAllItems() async {
    try {
    

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CountriesEntity?>> getItemById(String id) async {
    try {
    
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final remoteItem = remoteItems.firstWhere((item) => item.id == id,
          orElse: () => throw "Not found");
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(CountriesEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(CountriesEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }
}
