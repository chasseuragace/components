import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/jobs_search_results.dart'
    as search_entities;

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../domain/entities/jobs/entity.dart';
import '../../../domain/repositories/jobs/repository.dart';
import './di.dart';

// Search query (local UI state)
final searchQueryProvider = StateProvider<String>((ref) => '');

// Pagination state
final currentPageProvider = StateProvider<int>((ref) => 1);
final pageLimitProvider = StateProvider<int>((ref) => 10);

// Filters (local UI state)
class FiltersNotifier extends StateNotifier<Map<String, dynamic>> {
  FiltersNotifier() : super({});

  void setAll(Map<String, dynamic> filters) => state = Map.of(filters);
  void set(String key, dynamic value) {
    final next = Map<String, dynamic>.from(state);
    next[key] = value;
    state = next;
  }

  void remove(String key) {
    final next = Map<String, dynamic>.from(state);
    next.remove(key);
    state = next;
  }

  void clear() => state = {};
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<String, dynamic>>(
        (ref) => FiltersNotifier());

class GetAllJobsNotifier extends AsyncNotifier<search_entities.PaginatedJobsSearchResults?> {
  @override
  Future<search_entities.PaginatedJobsSearchResults?> build() async {
    final result = await ref.read(getAllJobsUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (paginatedResults) => paginatedResults,
    );
  }
}

class GetGroupedJobListings extends AsyncNotifier<GroupedJobsEntity> {
  @override
  Future<GroupedJobsEntity> build() async {
    final result = await ref.read(getGroupedJobsUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetJobsByIdNotifier extends AsyncNotifier<MobileJobEntity?> {
  @override
  build() async {
    return null; // Initially null
  }

  Future<void> getJobsById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getJobsByIdUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (item) => AsyncValue.data(item),
    );
  }
}

class AddJobsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addJobs(JobsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addJobsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllJobsProvider);
  }
}

class UpdateJobsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateJobs(JobsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateJobsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllJobsProvider);
  }
}

class DeleteJobsNotifier extends AsyncNotifier {
  @override
  build() {}

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteJobsUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllJobsProvider);
  }
}

class SearchJobsNotifier
    extends AsyncNotifier<search_entities.PaginatedJobsSearchResults?> {
  @override
  Future<search_entities.PaginatedJobsSearchResults?> build() async {
    return null; // Initially null
  }

  Future<void> searchJobs(JobSearchDTO searchParams) async {
    state = const AsyncValue.loading();
    final result = await ref.read(searchJobsUseCaseProvider)(searchParams);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (results) => AsyncValue.data(results),
    );
  }

  Future<void> searchWithPagination() async {
    final query = ref.read(searchQueryProvider);
    final filters = ref.read(filtersProvider);
    final currentPage = ref.read(currentPageProvider);
    final limit = ref.read(pageLimitProvider);

    final searchParams = JobSearchDTO(
      keyword: query.isNotEmpty ? query : null,
      country: filters['country'],
      minSalary: filters['minSalary']?.toDouble(),
      maxSalary: filters['maxSalary']?.toDouble(),
      currency: filters['currency'],
      page: currentPage,
      limit: limit,
      sortBy: filters['sortBy'],
      order: filters['order'],
    );

    await searchJobs(searchParams);
  }

  void clearResults() {
    state = const AsyncValue.data(null);
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

final getAllJobsProvider =
    AsyncNotifierProvider<GetAllJobsNotifier,  search_entities.PaginatedJobsSearchResults?>(() {
  return GetAllJobsNotifier();
});
final getGroupedJobsProvider =
    AsyncNotifierProvider<GetGroupedJobListings, GroupedJobsEntity>(() {
  return GetGroupedJobListings();
});

final getJobsByIdProvider =
    AsyncNotifierProvider<GetJobsByIdNotifier, MobileJobEntity?>(() {
  return GetJobsByIdNotifier();
});

final addJobsProvider = AsyncNotifierProvider<AddJobsNotifier, void>(() {
  return AddJobsNotifier();
});

final updateJobsProvider = AsyncNotifierProvider<UpdateJobsNotifier, void>(() {
  return UpdateJobsNotifier();
});

final deleteJobsProvider = AsyncNotifierProvider<DeleteJobsNotifier, void>(() {
  return DeleteJobsNotifier();
});

final searchJobsProvider = AsyncNotifierProvider<SearchJobsNotifier,
    search_entities.PaginatedJobsSearchResults?>(() {
  return SearchJobsNotifier();
});
