import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/splash/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllSplashNotifier extends AsyncNotifier<List<SplashEntity>> {
  @override
  Future<List<SplashEntity>> build() async {
    final result = await ref.read(getAllSplashUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetSplashByIdNotifier extends AsyncNotifier<SplashEntity?> {
  @override
  Future<SplashEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getSplashById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getSplashByIdUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddSplashNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addSplash(SplashEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addSplashUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllSplashProvider);
  }
}

class UpdateSplashNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateSplash(SplashEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateSplashUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllSplashProvider);
  }
}

class DeleteSplashNotifier extends AsyncNotifier {
  @override
  build() {}

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteSplashUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllSplashProvider);
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

final getAllSplashProvider =
    AsyncNotifierProvider<GetAllSplashNotifier, List<SplashEntity>>(() {
  return GetAllSplashNotifier();
});

final getSplashByIdProvider =
    AsyncNotifierProvider<GetSplashByIdNotifier, SplashEntity?>(() {
  return GetSplashByIdNotifier();
});

final addSplashProvider = AsyncNotifierProvider<AddSplashNotifier, void>(() {
  return AddSplashNotifier();
});

final updateSplashProvider =
    AsyncNotifierProvider<UpdateSplashNotifier, void>(() {
  return UpdateSplashNotifier();
});

final deleteSplashProvider =
    AsyncNotifierProvider<DeleteSplashNotifier, void>(() {
  return DeleteSplashNotifier();
});
