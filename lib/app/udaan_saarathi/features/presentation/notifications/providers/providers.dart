import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/notifications/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllNotificationsNotifier extends AsyncNotifier<List<NotificationsEntity>> {
  @override
  Future<List<NotificationsEntity>> build() async {
    final result = await ref.read(getAllNotificationsUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetNotificationsByIdNotifier extends AsyncNotifier<NotificationsEntity?> {
  @override
  Future<NotificationsEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getNotificationsById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getNotificationsByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddNotificationsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addNotifications(NotificationsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addNotificationsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllNotificationsProvider);
  }
}

class UpdateNotificationsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateNotifications(NotificationsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateNotificationsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllNotificationsProvider);
  }
}

class DeleteNotificationsNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteNotificationsUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllNotificationsProvider);
  }
}

Exception _mapFailureToException(Failure failure) {
  if (failure is ServerFailure) {
    return Exception('Server failure');
  } else if (failure is CacheFailure) {
    return Exception('Cache failure');
  } else {
    return Exception('Unexpected error');
  }
}

final getAllNotificationsProvider = AsyncNotifierProvider<GetAllNotificationsNotifier, List<NotificationsEntity>>(() {
  return GetAllNotificationsNotifier();
});

final getNotificationsByIdProvider = AsyncNotifierProvider<GetNotificationsByIdNotifier, NotificationsEntity?>(() {
  return GetNotificationsByIdNotifier();
});

final addNotificationsProvider = AsyncNotifierProvider<AddNotificationsNotifier, void>(() {
  return AddNotificationsNotifier();
});

final updateNotificationsProvider = AsyncNotifierProvider<UpdateNotificationsNotifier, void>(() {
  return UpdateNotificationsNotifier();
});

final deleteNotificationsProvider = AsyncNotifierProvider<DeleteNotificationsNotifier, void>(() {
  return DeleteNotificationsNotifier();
});
