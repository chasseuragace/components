import '../../../data/datasources/notifications/local_data_source.dart';
import '../../../data/datasources/notifications/remote_data_source.dart';
import '../../../data/repositories/notifications/repository_impl.dart';
import '../../../data/repositories/notifications/repository_impl_fake.dart';
import '../../../domain/usecases/notifications/get_all.dart';
import '../../../domain/usecases/notifications/get_by_id.dart';
import '../../../domain/usecases/notifications/add.dart';
import '../../../domain/usecases/notifications/update.dart';
import '../../../domain/usecases/notifications/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllNotificationsUseCaseProvider = Provider<GetAllNotificationsUseCase>((ref) {
  return GetAllNotificationsUseCase(ref.watch(rNotificationsRepositoryProvider));
});

final getNotificationsByIdUseCaseProvider = Provider<GetNotificationsByIdUseCase>((ref) {
  return GetNotificationsByIdUseCase(ref.watch(rNotificationsRepositoryProvider));
});

final addNotificationsUseCaseProvider = Provider<AddNotificationsUseCase>((ref) {
  return AddNotificationsUseCase(ref.watch(rNotificationsRepositoryProvider));
});

final updateNotificationsUseCaseProvider = Provider<UpdateNotificationsUseCase>((ref) {
  return UpdateNotificationsUseCase(ref.watch(rNotificationsRepositoryProvider));
});

final deleteNotificationsUseCaseProvider = Provider<DeleteNotificationsUseCase>((ref) {
  return DeleteNotificationsUseCase(ref.watch(rNotificationsRepositoryProvider));
});

final rNotificationsRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataNotificationsSourceProvider);
  final remote = ref.read(remoteDataNotificationsSourceProvider);
  return NotificationsRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataNotificationsSourceProvider = Provider<NotificationsLocalDataSource>((ref) {
  return NotificationsLocalDataSourceImpl();
});

final remoteDataNotificationsSourceProvider = Provider<NotificationsRemoteDataSource>((ref) {
  return NotificationsRemoteDataSourceImpl();
});
