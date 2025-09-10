import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/notifications/entity.dart';
import '../../../domain/repositories/notifications/repository.dart';
import '../../datasources/notifications/local_data_source.dart';
import '../../datasources/notifications/remote_data_source.dart';
import '../../models/notifications/model.dart';
// Fake data for Notificationss
      final remoteItems = [
        NotificationsModel(

            rawJson: {},
          id: '1',
          name: 'Admin',
        ),
        NotificationsModel(
        rawJson: {},
          id: '2',
          name: 'User',
        ),
        NotificationsModel(
        rawJson: {},
          id: '3',
          name: 'Guest',
        ),
      ];
class NotificationsRepositoryFake implements NotificationsRepository {
  final NotificationsLocalDataSource localDataSource;
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<NotificationsEntity>>> getAllItems() async {
    try {
    

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationsEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem(NotificationsEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(NotificationsEntity entity) async {
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
