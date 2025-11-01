import '../../../data/repositories/notification/repository_impl.dart';
import '../../../domain/usecases/notification/get_notifications.dart';
import '../../../domain/usecases/notification/get_notification_by_id.dart';
import '../../../domain/usecases/notification/mark_as_read.dart';
import '../../../domain/usecases/notification/mark_all_as_read.dart';
import '../../../domain/usecases/notification/get_unread_count.dart';
import '../../../data/repositories/auth/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  return GetNotificationsUseCase(ref.watch(notificationRepositoryProvider));
});

final getNotificationByIdUseCaseProvider = Provider<GetNotificationByIdUseCase>((ref) {
  return GetNotificationByIdUseCase(ref.watch(notificationRepositoryProvider));
});

final markAsReadUseCaseProvider = Provider<MarkAsReadUseCase>((ref) {
  return MarkAsReadUseCase(ref.watch(notificationRepositoryProvider));
});

final markAllAsReadUseCaseProvider = Provider<MarkAllAsReadUseCase>((ref) {
  return MarkAllAsReadUseCase(ref.watch(notificationRepositoryProvider));
});

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>((ref) {
  return GetUnreadCountUseCase(ref.watch(notificationRepositoryProvider));
});

final notificationRepositoryProvider = Provider((ref) {
  final storage = ref.watch(tokenStorageProvider);
  return NotificationRepositoryImpl(storage: storage);
});
