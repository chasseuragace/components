import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/search/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllSearchNotifier extends AsyncNotifier<List<SearchEntity>> {
  @override
  Future<List<SearchEntity>> build() async {
    final result = await ref.read(getAllSearchUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetSearchByIdNotifier extends AsyncNotifier<SearchEntity?> {
  @override
  Future<SearchEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getSearchById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getSearchByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddSearchNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addSearch(SearchEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addSearchUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllSearchProvider);
  }
}

class UpdateSearchNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateSearch(SearchEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateSearchUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllSearchProvider);
  }
}

class DeleteSearchNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteSearchUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllSearchProvider);
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

final getAllSearchProvider = AsyncNotifierProvider<GetAllSearchNotifier, List<SearchEntity>>(() {
  return GetAllSearchNotifier();
});

final getSearchByIdProvider = AsyncNotifierProvider<GetSearchByIdNotifier, SearchEntity?>(() {
  return GetSearchByIdNotifier();
});

final addSearchProvider = AsyncNotifierProvider<AddSearchNotifier, void>(() {
  return AddSearchNotifier();
});

final updateSearchProvider = AsyncNotifierProvider<UpdateSearchNotifier, void>(() {
  return UpdateSearchNotifier();
});

final deleteSearchProvider = AsyncNotifierProvider<DeleteSearchNotifier, void>(() {
  return DeleteSearchNotifier();
});
