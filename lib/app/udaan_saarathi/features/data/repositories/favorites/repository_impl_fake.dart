import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Favorites/entity.dart';
import '../../../domain/repositories/Favorites/repository.dart';
import '../../datasources/Favorites/local_data_source.dart';
import '../../datasources/Favorites/remote_data_source.dart';
import '../../models/Favorites/model.dart';

// Fake data for Favoritess
final remoteItems = [
  FavoritesModel(
    rawJson: {},
    id: '1',
    name: 'Admin',
  ),
  FavoritesModel(
    rawJson: {},
    id: '2',
    name: 'User',
  ),
  FavoritesModel(
    rawJson: {},
    id: '3',
    name: 'Guest',
  ),
];

class FavoritesRepositoryFake implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<FavoritesEntity>>> getAllItems() async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, FavoritesEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem({required String jobId}) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      print("Added to favorites");
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(FavoritesEntity entity) async {
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
