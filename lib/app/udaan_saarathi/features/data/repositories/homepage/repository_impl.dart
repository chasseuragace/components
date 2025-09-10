import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/homepage/entity.dart';
import '../../../domain/repositories/homepage/repository.dart';
import '../../datasources/homepage/local_data_source.dart';
import '../../datasources/homepage/remote_data_source.dart';
import '../../models/homepage/model.dart';
class HomepageRepositoryImpl implements HomepageRepository {
  final HomepageLocalDataSource localDataSource;
  final HomepageRemoteDataSource remoteDataSource;

  HomepageRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<HomepageEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, HomepageEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(HomepageEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as HomepageModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(HomepageEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as HomepageModel));
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
extension model on HomepageEntity {
  HomepageModel toModel() {
    throw UnimplementedError();
  }
}
