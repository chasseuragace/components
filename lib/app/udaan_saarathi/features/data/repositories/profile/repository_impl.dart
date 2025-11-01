import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/profile/entity.dart';
import '../../../domain/repositories/profile/repository.dart';
import '../../datasources/profile/local_data_source.dart';
import '../../datasources/profile/remote_data_source.dart';
import '../../models/profile/model.dart';
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ProfileEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(ProfileEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as ProfileModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(ProfileEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as ProfileModel));
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
extension model on ProfileEntity {
  ProfileModel toModel() {
    throw UnimplementedError();
  }
}
