import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/splash/entity.dart';
import '../../../domain/repositories/splash/repository.dart';
import '../../datasources/splash/local_data_source.dart';
import '../../datasources/splash/remote_data_source.dart';
import '../../models/splash/model.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;
  final SplashRemoteDataSource remoteDataSource;

  SplashRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SplashEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SplashEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(SplashEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as SplashModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(SplashEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as SplashModel));
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

extension model on SplashEntity {
  SplashModel toModel() {
    throw UnimplementedError();
  }
}
