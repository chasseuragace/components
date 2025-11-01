import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/notification/entity.dart';
import '../../../domain/repositories/notification/repository.dart';
import '../../../../core/usecases/usecase.dart';
import './di.dart';

// State classes for pagination
class NotificationListState {
  final List<NotificationEntity> items;
  final int total;
  final int page;
  final int limit;
  final int unreadCount;
  final bool hasMore;
  final bool isLoadingMore;

  NotificationListState({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.unreadCount,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  NotificationListState copyWith({
    List<NotificationEntity>? items,
    int? total,
    int? page,
    int? limit,
    int? unreadCount,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return NotificationListState(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// Notification list notifier with pagination
class NotificationListNotifier extends AsyncNotifier<NotificationListState> {
  bool _unreadOnly = false;
  static const int _pageSize = 20;

  @override
  Future<NotificationListState> build() async {
    return _loadNotifications(page: 1, isRefresh: true);
  }

  Future<NotificationListState> _loadNotifications({
    required int page,
    bool isRefresh = false,
  }) async {
    final params = GetNotificationsParams(
      page: page,
      limit: _pageSize,
      unreadOnly: _unreadOnly,
    );

    final result = await ref.read(getNotificationsUseCaseProvider)(params);
    
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (notificationResult) {
        final currentState = state.valueOrNull;
        final newItems = isRefresh || currentState == null
            ? notificationResult.items
            : [...currentState.items, ...notificationResult.items];

        return NotificationListState(
          items: newItems,
          total: notificationResult.total,
          page: page,
          limit: _pageSize,
          unreadCount: notificationResult.unreadCount,
          hasMore: newItems.length < notificationResult.total,
        );
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.hasMore || currentState.isLoadingMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final newState = await _loadNotifications(page: currentState.page + 1);
      state = AsyncValue.data(newState);
    } catch (error, stackTrace) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final newState = await _loadNotifications(page: 1, isRefresh: true);
      state = AsyncValue.data(newState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleUnreadFilter() async {
    _unreadOnly = !_unreadOnly;
    await refresh();
  }

  bool get isUnreadFilterActive => _unreadOnly;
}

// Mark as read notifier
class MarkAsReadNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> markAsRead(String notificationId) async {
    state = const AsyncValue.loading();
    final result = await ref.read(markAsReadUseCaseProvider)(notificationId);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
    
    // Refresh the notification list after marking as read
    if (state.hasValue) {
      ref.invalidate(notificationListProvider);
    }
  }
}

// Mark all as read notifier
class MarkAllAsReadNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    final result = await ref.read(markAllAsReadUseCaseProvider)(NoParm());
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (count) => const AsyncValue.data(null),
    );
    
    // Refresh the notification list after marking all as read
    if (state.hasValue) {
      ref.invalidate(notificationListProvider);
    }
  }
}

// Get notification by ID notifier
class GetNotificationByIdNotifier extends AsyncNotifier<NotificationEntity?> {
  @override
  Future<NotificationEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getNotificationById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getNotificationByIdUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (notification) => AsyncValue.data(notification),
    );
  }
}

Exception _mapFailureToException(Failure failure) {
  if (failure is ServerFailure) {
    return Exception('Server failure: ${failure.message}');
  } else if (failure is CacheFailure) {
    return Exception('Cache failure: ${failure.message}');
  } else {
    return Exception('Unexpected error: ${failure.message}');
  }
}

// Provider definitions
final notificationListProvider = AsyncNotifierProvider<NotificationListNotifier, NotificationListState>(() {
  return NotificationListNotifier();
});

final markAsReadProvider = AsyncNotifierProvider<MarkAsReadNotifier, void>(() {
  return MarkAsReadNotifier();
});

final markAllAsReadProvider = AsyncNotifierProvider<MarkAllAsReadNotifier, void>(() {
  return MarkAllAsReadNotifier();
});

final getNotificationByIdProvider = AsyncNotifierProvider<GetNotificationByIdNotifier, NotificationEntity?>(() {
  return GetNotificationByIdNotifier();
});

// Unread count provider using the dedicated use case
final unreadCountProvider = FutureProvider<int>((ref) async {
  final useCase = ref.read(getUnreadCountUseCaseProvider);
  final result = await useCase(NoParm());
  
  return result.fold(
    (failure) => throw _mapFailureToException(failure),
    (count) => count,
  );
});
