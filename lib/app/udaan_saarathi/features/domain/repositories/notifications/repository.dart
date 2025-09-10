import 'package:dartz/dartz.dart';
import '../../entities/notifications/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationsEntity>>> getAllItems();
  Future<Either<Failure, NotificationsEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(NotificationsEntity entity);
  Future<Either<Failure, Unit>> updateItem(NotificationsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
