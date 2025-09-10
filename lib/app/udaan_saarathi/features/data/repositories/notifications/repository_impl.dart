import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/notifications/entity.dart';
import '../../../domain/repositories/notifications/repository.dart';
import '../../datasources/notifications/local_data_source.dart';
import '../../datasources/notifications/remote_data_source.dart';
import '../../models/notifications/model.dart';
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsLocalDataSource localDataSource;
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<NotificationsEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationsEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(NotificationsEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as NotificationsModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(NotificationsEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as NotificationsModel));
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
extension model on NotificationsEntity {
  NotificationsModel toModel() {
    throw UnimplementedError();
  }
}
