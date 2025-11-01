import 'package:dartz/dartz.dart';
import '../../entities/notification/entity.dart';
import '../../../../core/errors/failures.dart';

class GetNotificationsParams {
  final int page;
  final int limit;
  final bool unreadOnly;

  GetNotificationsParams({
    this.page = 1,
    this.limit = 20,
    this.unreadOnly = false,
  });
}

class NotificationListResult {
  final List<NotificationEntity> items;
  final int total;
  final int page;
  final int limit;
  final int unreadCount;

  NotificationListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.unreadCount,
  });
}

abstract class NotificationRepository {
  Future<Either<Failure, NotificationListResult>> getNotifications(GetNotificationsParams params);
  Future<Either<Failure, NotificationEntity?>> getNotificationById(String id);
  Future<Either<Failure, NotificationEntity?>> markAsRead(String id);
  Future<Either<Failure, int>> markAllAsRead();
  Future<Either<Failure, int>> getUnreadCount();
}
