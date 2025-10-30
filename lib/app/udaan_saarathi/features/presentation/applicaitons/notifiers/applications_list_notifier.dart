import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_pagination_wrapper.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/applicaitons/params.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/providers/di.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/errors/failures.dart';

class ApplicationsListNotifier extends FamilyAsyncNotifier<ApplicationPaginationWrapper, String?> {
  int _currentPage = 1;
  bool _hasReachedMax = false;
  
  @override
  Future<ApplicationPaginationWrapper> build(String? status) async {
    _currentPage = 1;
    _hasReachedMax = false;
    return _fetchPage(_currentPage, status);
  }
  
  Future<ApplicationPaginationWrapper> _fetchPage(int page, String? status) async {
    final result = await ref.read(getAllApplicaitonsUseCaseProvider)(
      GetAllApplicationsParams(page: page, status: status),
    );
    
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (wrapper) {
        _hasReachedMax = wrapper.items.length < (wrapper.limit ?? 10);
        return wrapper;
      },
    );
  }
  
  Future<void> loadPage(int page, String? status) async {
    if (state.isLoading) return;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage(page, status));
    if (!state.hasError) {
      _currentPage = page;
    }
  }
  
  Future<void> loadNextPage(String? status) async {
    if (state.isLoading || _hasReachedMax) return;
    
    final nextPage = _currentPage + 1;
    final currentState = state.valueOrNull;
    
    if (currentState == null) return;
    
    state = AsyncValue.data(currentState.copyWith(
      items: [...currentState.items],
      isLoadingMore: true,
    ));
    
    final result = await _fetchPage(nextPage, status);
    
    state = AsyncValue.data(ApplicationPaginationWrapper(
      items: [...currentState.items, ...result.items],
      page: nextPage,
      total: result.total,
      limit: result.limit,
    ));
    
    _currentPage = nextPage;
    _hasReachedMax = result.items.length < (result.limit ?? 10);
  }
  
  Future<void> refresh(String? status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage(1, status));
    _currentPage = 1;
    _hasReachedMax = false;
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
}

final applicationsListProvider = AsyncNotifierProvider.family<ApplicationsListNotifier, ApplicationPaginationWrapper, String?>(
  ApplicationsListNotifier.new,
);
