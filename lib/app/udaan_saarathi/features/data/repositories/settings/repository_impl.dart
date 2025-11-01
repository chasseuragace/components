import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Settings/entity.dart';
import '../../../domain/repositories/Settings/repository.dart';
import '../../datasources/Settings/local_data_source.dart';
import '../../datasources/Settings/remote_data_source.dart';
import '../../models/Settings/model.dart';
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SettingsEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SettingsEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(SettingsEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as SettingsModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(SettingsEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as SettingsModel));
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
extension model on SettingsEntity {
  SettingsModel toModel() {
    throw UnimplementedError();
  }
}
