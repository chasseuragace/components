import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/preferences/entity.dart';
import '../../../domain/repositories/preferences/repository.dart';
import '../../datasources/preferences/local_data_source.dart';
import '../../datasources/preferences/remote_data_source.dart';
import '../../models/preferences/model.dart';
class PreferencesRepositoryImpl implements PreferencesRepository {
  final PreferencesLocalDataSource localDataSource;
  final PreferencesRemoteDataSource remoteDataSource;

  PreferencesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<PreferencesEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PreferencesEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(PreferencesEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as PreferencesModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(PreferencesEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as PreferencesModel));
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
extension model on PreferencesEntity {
  PreferencesModel toModel() {
    throw UnimplementedError();
  }
}
