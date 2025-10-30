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

/// Paginated search state
class PaginatedSearchState {
  final List<JobsEntity> items;
  final int page;
  final int limit;
  final int total;
  final bool isLoading;
  final bool hasMore;
  final JobSearchDTO? baseDto;

  const PaginatedSearchState({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.isLoading,
    required this.hasMore,
    required this.baseDto,
  });

  factory PaginatedSearchState.initial() => const PaginatedSearchState(
        items: [],
        page: 0,
        limit: 10,
        total: 0,
        isLoading: false,
        hasMore: false,
        baseDto: null,
      );

  PaginatedSearchState copyWith({
    List<JobsEntity>? items,
    int? page,
    int? limit,
    int? total,
    bool? isLoading,
    bool? hasMore,
    JobSearchDTO? baseDto,
  }) {
    return PaginatedSearchState(
      items: items ?? this.items,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      baseDto: baseDto ?? this.baseDto,
    );
  }
}

class PaginatedSearchNotifier extends StateNotifier<PaginatedSearchState> {
  PaginatedSearchNotifier(this.ref) : super(PaginatedSearchState.initial());
  final Ref ref;

  Future<void> reset(JobSearchDTO baseDto, {int limit = 10}) async {
    state = state.copyWith(
      isLoading: true,
      items: [],
      page: 0,
      limit: limit,
      total: 0,
      hasMore: false,
      baseDto: baseDto,
    );
    await _fetch(page: 1);
  }

  Future<void> loadNext() async {
    if (state.isLoading || !state.hasMore) return;
    final nextPage = state.page + 1;
    await _fetch(page: nextPage);
  }

  Future<void> _fetch({required int page}) async {
    print("fetching");
    final dto = state.baseDto;
    print(dto);
    if (dto == null) return;
    state = state.copyWith(isLoading: true);
    final result = await ref.read(searchJobsUseCaseProvider)(JobSearchDTO(
      keyword: dto.keyword,
      country: dto.country,
      minSalary: dto.minSalary,
      maxSalary: dto.maxSalary,
      currency: dto.currency,
      page: page,
      limit: state.limit,
      sortBy: dto.sortBy,
      order: dto.order,
    ));

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, hasMore: false);
      },
      (paginated) {
        final newItems = List<JobsEntity>.from(state.items)
          ..addAll(paginated.data);
        final bool receivedEmptyPage = paginated.data.isEmpty;
        final bool computedHasMore = receivedEmptyPage
            ? false
            : ((paginated.page * paginated.limit) < paginated.total);
        state = state.copyWith(
          items: newItems,
          page: paginated.page,
          limit: paginated.limit,
          total: paginated.total,
          hasMore: computedHasMore,
          isLoading: false,
        );
      },
    );
  }

  void clear() {
    state = PaginatedSearchState.initial();
  }
}

final paginatedSearchProvider =
    StateNotifierProvider<PaginatedSearchNotifier, PaginatedSearchState>((ref) {
  return PaginatedSearchNotifier(ref);
});

/// All Jobs pagination using the search endpoint with empty filters
class AllJobsPaginationNotifier extends StateNotifier<PaginatedSearchState> {
  AllJobsPaginationNotifier(this.ref) : super(PaginatedSearchState.initial());
  final Ref ref;

  Future<void> reset({int limit = 10}) async {
    // baseDto with no filters to fetch "all"
    final dto = const JobSearchDTO(page: 1, limit: 10);
    state = state.copyWith(
      isLoading: true,
      items: [],
      page: 0,
      limit: limit,
      total: 0,
      hasMore: false,
      baseDto: dto,
    );
    await _fetch(page: 1);
  }

  Future<void> loadNext() async {
    if (state.isLoading || !state.hasMore) return;
    final next = state.page + 1;
    await _fetch(page: next);
  }

  Future<void> _fetch({required int page}) async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(searchJobsUseCaseProvider)(JobSearchDTO(
      keyword: null,
      country: null,
      minSalary: null,
      maxSalary: null,
      currency: null,
      page: page,
      limit: state.limit,
      sortBy: null,
      order: null,
    ));
    result.fold(
      (_) => state = state.copyWith(isLoading: false, hasMore: false),
      (paginated) {
        final newItems = List<JobsEntity>.from(state.items)
          ..addAll(paginated.data);
        final receivedEmpty = paginated.data.isEmpty;
        final hasMore = receivedEmpty
            ? false
            : ((paginated.page * paginated.limit) < paginated.total);
        state = state.copyWith(
          items: newItems,
          page: paginated.page,
          limit: paginated.limit,
          total: paginated.total,
          hasMore: hasMore,
          isLoading: false,
        );
      },
    );
  }
}

final paginatedAllJobsProvider =
    StateNotifierProvider<AllJobsPaginationNotifier, PaginatedSearchState>(
        (ref) {
  return AllJobsPaginationNotifier(ref);
});

class GetAllJobsNotifier
    extends AsyncNotifier<search_entities.PaginatedJobsSearchResults?> {
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

final getAllJobsProvider = AsyncNotifierProvider<GetAllJobsNotifier,
    search_entities.PaginatedJobsSearchResults?>(() {
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
