import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/homepage/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllHomepageNotifier extends AsyncNotifier<List<HomepageEntity>> {
  @override
  Future<List<HomepageEntity>> build() async {
    final result = await ref.read(getAllHomepageUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetHomepageByIdNotifier extends AsyncNotifier<HomepageEntity?> {
  @override
  Future<HomepageEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getHomepageById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getHomepageByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddHomepageNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addHomepage(HomepageEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addHomepageUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllHomepageProvider);
  }
}

class UpdateHomepageNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateHomepage(HomepageEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateHomepageUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllHomepageProvider);
  }
}

class DeleteHomepageNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteHomepageUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllHomepageProvider);
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

final getAllHomepageProvider = AsyncNotifierProvider<GetAllHomepageNotifier, List<HomepageEntity>>(() {
  return GetAllHomepageNotifier();
});

final getHomepageByIdProvider = AsyncNotifierProvider<GetHomepageByIdNotifier, HomepageEntity?>(() {
  return GetHomepageByIdNotifier();
});

final addHomepageProvider = AsyncNotifierProvider<AddHomepageNotifier, void>(() {
  return AddHomepageNotifier();
});

final updateHomepageProvider = AsyncNotifierProvider<UpdateHomepageNotifier, void>(() {
  return UpdateHomepageNotifier();
});

final deleteHomepageProvider = AsyncNotifierProvider<DeleteHomepageNotifier, void>(() {
  return DeleteHomepageNotifier();
});
