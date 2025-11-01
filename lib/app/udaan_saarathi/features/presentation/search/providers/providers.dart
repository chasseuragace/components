import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/search/entity.dart';
import '../../../domain/entities/search/search_params.dart';
import '../../../domain/entities/search/paginated_search_result.dart';

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

class SearchAgenciesNotifier extends AsyncNotifier<PaginatedSearchResult> {
  bool _isLoadingMore = false;
  SearchParams? _lastSearchParams;

  @override
  Future<PaginatedSearchResult> build() async {
    // Initial empty state
    return PaginatedSearchResult(
      data: [],
      total: 0,
      page: 1,
      limit: 10,
      totalPages: 0,
    );
  }

  Future<void> search(SearchParams params) async {
    // Reset page to 1 for new search
    _lastSearchParams = params;
    _isLoadingMore = false;
    
    // If no keyword, reset to empty state without API call
    if (params.keyword == null || params.keyword!.isEmpty) {
      state = AsyncValue.data(PaginatedSearchResult(
        data: [],
        total: 0,
        page: 1,
        limit: params.limit,
        totalPages: 0,
      ));
      return;
    }
    
    state = const AsyncValue.loading();
    
    final result = await ref.read(searchAgenciesUseCaseProvider)(params);
    state = result.fold(
      (failure) => AsyncValue.error(_mapFailureToException(failure), StackTrace.current),
      (paginatedResult) => AsyncValue.data(paginatedResult),
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _lastSearchParams == null) return;
    
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    
    // Check if there are more pages to load
    if (currentState.page >= currentState.totalPages) return;
    
    _isLoadingMore = true;
    
    final nextPage = currentState.page + 1;
    final params = SearchParams(
      keyword: _lastSearchParams!.keyword,
      page: nextPage,
      limit: _lastSearchParams!.limit,
      sortBy: _lastSearchParams!.sortBy,
      sortOrder: _lastSearchParams!.sortOrder,
    );
    
    final result = await ref.read(searchAgenciesUseCaseProvider)(params);
    
    result.fold(
      (failure) {
        _isLoadingMore = false;
        // Keep current state but show error
        state = AsyncValue.error(_mapFailureToException(failure), StackTrace.current);
      },
      (newPage) {
        _isLoadingMore = false;
        // Append new results to existing ones
        state = AsyncValue.data(PaginatedSearchResult(
          data: [...currentState.data, ...newPage.data],
          total: newPage.total,
          page: newPage.page,
          limit: newPage.limit,
          totalPages: newPage.totalPages,
        ));
      },
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

final searchAgenciesProvider = AsyncNotifierProvider<SearchAgenciesNotifier, PaginatedSearchResult>(() {
  return SearchAgenciesNotifier();
});
