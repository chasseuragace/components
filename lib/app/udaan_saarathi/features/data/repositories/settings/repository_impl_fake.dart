import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Settings/entity.dart';
import '../../../domain/repositories/Settings/repository.dart';
import '../../datasources/Settings/local_data_source.dart';
import '../../datasources/Settings/remote_data_source.dart';
import '../../models/Settings/model.dart';
// Fake data for Settingss
      final remoteItems = [
        SettingsModel(

            rawJson: {},
          id: '1',
          name: 'Admin',
        ),
        SettingsModel(
        rawJson: {},
          id: '2',
          name: 'User',
        ),
        SettingsModel(
        rawJson: {},
          id: '3',
          name: 'Guest',
        ),
      ];
class SettingsRepositoryFake implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SettingsEntity>>> getAllItems() async {
    try {
    

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SettingsEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem(SettingsEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(SettingsEntity entity) async {
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
