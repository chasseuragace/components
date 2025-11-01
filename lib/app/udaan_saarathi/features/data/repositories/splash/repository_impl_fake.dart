import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/splash/entity.dart';
import '../../../domain/repositories/splash/repository.dart';
import '../../datasources/splash/local_data_source.dart';
import '../../datasources/splash/remote_data_source.dart';
import '../../models/splash/model.dart';

// Fake data for Splashs
final remoteItems = [
  SplashModel(
    rawJson: {},
    id: '1',
    name: 'Admin',
  ),
  SplashModel(
    rawJson: {},
    id: '2',
    name: 'User',
  ),
  SplashModel(
    rawJson: {},
    id: '3',
    name: 'Guest',
  ),
];

class SplashRepositoryFake implements SplashRepository {
  final SplashLocalDataSource localDataSource;
  final SplashRemoteDataSource remoteDataSource;

  SplashRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SplashEntity>>> getAllItems() async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SplashEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem(SplashEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(SplashEntity entity) async {
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
