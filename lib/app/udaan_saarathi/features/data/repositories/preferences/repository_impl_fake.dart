import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/entities/preferences/entity.dart';
import '../../../domain/repositories/preferences/repository.dart';
import '../../datasources/preferences/local_data_source.dart';
import '../../datasources/preferences/remote_data_source.dart';
import '../../models/preferences/model.dart';

// Fake data for Preferencess
final remoteItems = [
  PreferencesModel(
    rawJson: {},
    id: '1',
    name: 'Admin',
  ),
  PreferencesModel(
    rawJson: {},
    id: '2',
    name: 'User',
  ),
  PreferencesModel(
    rawJson: {},
    id: '3',
    name: 'Guest',
  ),
];

class PreferencesRepositoryFake implements PreferencesRepository {
  final PreferencesLocalDataSource localDataSource;
  final PreferencesRemoteDataSource remoteDataSource;

  PreferencesRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<PreferencesEntity>>> getAllItems() async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PreferencesEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem(PreferencesEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(PreferencesEntity entity) async {
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
