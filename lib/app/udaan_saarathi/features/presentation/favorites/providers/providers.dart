import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../domain/entities/Favorites/entity.dart';
import './di.dart';

class GetAllFavoritesNotifier extends AsyncNotifier<List<FavoritesEntity>> {
  @override
  Future<List<FavoritesEntity>> build() async {
    final result = await ref.read(getAllFavoritesUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetFavoritesByIdNotifier extends AsyncNotifier<FavoritesEntity?> {
  @override
  Future<FavoritesEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getFavoritesById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getFavoritesByIdUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddFavoritesNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addFavorites(String jobId) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addFavoritesUseCaseProvider)(jobId);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllFavoritesProvider);
  }
}

class UpdateFavoritesNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateFavorites(FavoritesEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateFavoritesUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllFavoritesProvider);
  }
}

class DeleteFavoritesNotifier extends AsyncNotifier {
  @override
  build() {}

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteFavoritesUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllFavoritesProvider);
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

final getAllFavoritesProvider =
    AsyncNotifierProvider<GetAllFavoritesNotifier, List<FavoritesEntity>>(() {
  return GetAllFavoritesNotifier();
});

final getFavoritesByIdProvider =
    AsyncNotifierProvider<GetFavoritesByIdNotifier, FavoritesEntity?>(() {
  return GetFavoritesByIdNotifier();
});

final addFavoritesProvider =
    AsyncNotifierProvider<AddFavoritesNotifier, void>(() {
  return AddFavoritesNotifier();
});

final updateFavoritesProvider =
    AsyncNotifierProvider<UpdateFavoritesNotifier, void>(() {
  return UpdateFavoritesNotifier();
});

final deleteFavoritesProvider =
    AsyncNotifierProvider<DeleteFavoritesNotifier, void>(() {
  return DeleteFavoritesNotifier();
});
