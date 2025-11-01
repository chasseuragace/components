import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/config/api_config.dart';
import '../../../domain/entities/notification/entity.dart';
import '../../../domain/repositories/notification/repository.dart';
import '../../models/notification/model.dart';
import '../auth/token_storage.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsApi _api;
  final TokenStorage _storage;

  NotificationRepositoryImpl({
    required TokenStorage storage,
    NotificationsApi? api,
  })  : _storage = storage,
        _api = api ?? ApiConfig.client().getNotificationsApi();

  @override
  Future<Either<Failure, NotificationListResult>> getNotifications(GetNotificationsParams params) async {
    try {
      final candidateId = await _storage.getCandidateId();
      print('🔍 Fetching notifications for candidate: $candidateId (page: ${params.page}, limit: ${params.limit}, unreadOnly: ${params.unreadOnly})');
      
      if (candidateId == null) {
        print('❌ No candidate ID found in storage for notifications');
        return left(ServerFailure(
          message: 'No candidate ID available for notifications',
          details: 'Candidate ID is required to fetch notifications but was not found in storage',
        ));
      }

      print('📡 Making API call to get notifications...');
      final response = await _api.notificationControllerGetNotifications(
        candidateId: candidateId,
        page: params.page,
        limit: params.limit,
        unreadOnly: params.unreadOnly,
      );

      print('✅ Notifications API response received: ${response.statusCode}');
      
      if (response.statusCode == 200 && response.data != null) {
        final notificationListDto = response.data!;
        
        // Convert DTOs to domain models
        final notificationModels = notificationListDto.items.map((dto) => 
          NotificationModel.fromNotificationResponseDto(dto)
        ).toList();
        
        final result = NotificationListResult(
          items: notificationModels,
          total: notificationListDto.total.toInt(),
          page: int.parse(notificationListDto.page.toString()),
          limit: notificationListDto.limit.toInt(),
          unreadCount: notificationListDto.unreadCount.toInt(),
        );
        
        return right(result);
      } else {
        print('❌ Notifications API returned error: ${response.statusCode}');
        return left(ServerFailure(
          message: 'Failed to fetch notifications',
          details: 'API returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
        ));
      }
    } catch (error) {
      print('❌ Error fetching notifications: $error');
      return left(ServerFailure(message: 'Failed to fetch notifications: $error'));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity?>> getNotificationById(String id) async {
    try {
      print('🔍 Fetching notification by ID: $id');
      
      // For now, we'll get all notifications and filter by ID
      // This can be optimized with a dedicated API endpoint later
      final notificationsResult = await getNotifications(GetNotificationsParams(page: 1, limit: 100));
      
      return notificationsResult.fold(
        (failure) => left(failure),
        (result) {
          try {
            final notification = result.items.firstWhere((n) => n.id == id);
            return right(notification);
          } catch (e) {
            return left(ServerFailure(message: 'Notification not found with ID: $id'));
          }
        },
      );
    } catch (error) {
      print('❌ Error fetching notification by ID: $error');
      return left(ServerFailure(message: 'Failed to fetch notification: $error'));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity?>> markAsRead(String id) async {
    try {
      print('🔍 Marking notification as read: $id');
      
      print('📡 Making API call to mark notification as read...');
      final response = await _api.notificationControllerMarkAsRead(id: id);
      
      print('✅ Mark as read API response: ${response.statusCode}');
      
      if (response.statusCode == 200 && response.data != null) {
        final markAsReadDto = response.data!;
        
        // Return the updated notification if available in response
        if (markAsReadDto.notification != null) {
          final updatedNotification = NotificationModel.fromNotificationResponseDto(markAsReadDto.notification!);
          return right(updatedNotification);
        } else {
          // If no notification in response, fetch it separately
          final updatedNotificationResult = await getNotificationById(id);
          return updatedNotificationResult;
        }
      } else {
        print('❌ Mark as read API returned error: ${response.statusCode}');
        return left(ServerFailure(
          message: 'Failed to mark notification as read',
          details: 'API returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
        ));
      }
    } catch (error) {
      print('❌ Error marking notification as read: $error');
      return left(ServerFailure(message: 'Failed to mark notification as read: $error'));
    }
  }

  @override
  Future<Either<Failure, int>> markAllAsRead() async {
    try {
      final candidateId = await _storage.getCandidateId();
      print('🔍 Marking all notifications as read for candidate: $candidateId');
      
      if (candidateId == null) {
        print('❌ No candidate ID found in storage for mark all as read');
        return left(ServerFailure(
          message: 'No candidate ID available for mark all as read',
          details: 'Candidate ID is required to mark all notifications as read but was not found in storage',
        ));
      }

      print('📡 Making API call to mark all notifications as read...');
      final response = await _api.notificationControllerMarkAllAsRead(
        candidateId: candidateId,
      );
      
      print('✅ Mark all as read API response: ${response.statusCode}');
      
      if (response.statusCode == 200 && response.data != null) {
        final markAllAsReadDto = response.data!;
        final markedCount = markAllAsReadDto.markedCount.toInt();
        return right(markedCount);
      } else {
        print('❌ Mark all as read API returned error: ${response.statusCode}');
        return left(ServerFailure(
          message: 'Failed to mark all notifications as read',
          details: 'API returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
        ));
      }
    } catch (error) {
      print('❌ Error marking all notifications as read: $error');
      return left(ServerFailure(message: 'Failed to mark all notifications as read: $error'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final candidateId = await _storage.getCandidateId();
      print('🔍 Fetching unread notification count for candidate: $candidateId');
      
      if (candidateId == null) {
        print('❌ No candidate ID found in storage for unread count');
        return left(ServerFailure(
          message: 'No candidate ID available for unread count',
          details: 'Candidate ID is required to fetch unread count but was not found in storage',
        ));
      }

      print('📡 Making API call to get unread notification count...');
      final response = await _api.notificationControllerGetUnreadCount(
        candidateId: candidateId,
      );

      print('✅ Unread count API response received: ${response.statusCode}');
      
      if (response.statusCode == 200 && response.data != null) {
        final unreadCountDto = response.data!;
        final count = (unreadCountDto.count??0).toInt();
        // return right(5);
        return right(count);
      } else {
        print('❌ Unread count API returned error: ${response.statusCode}');
        return left(ServerFailure(
          message: 'Failed to fetch unread notification count',
          details: 'API returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
        ));
      }
    } catch (error) {
      print('❌ Error fetching unread notification count: $error');
      return left(ServerFailure(message: 'Failed to fetch unread notification count: $error'));
    }
  }

}
