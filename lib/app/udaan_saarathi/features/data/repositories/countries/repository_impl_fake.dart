import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import '../../../../core/config/api_config.dart' show ApiConfig;
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/countries/entity.dart';
import '../../../domain/repositories/countries/repository.dart';
import '../../datasources/countries/local_data_source.dart';
import '../../datasources/countries/remote_data_source.dart';
import '../../models/countries/model.dart';
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
  final CountriesApi _api;
  CountriesRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  }):_api =ApiConfig.client().getCountriesApi();

  @override
  Future<Either<Failure, List<CountriesEntity>>> getAllItems() async {
    try {
    
final data = await _api.countryControllerList();
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(data.data!.map((model) => CountriesModel(id: model.id, name: model.countryName, rawJson: model.toJson())).toList());
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
