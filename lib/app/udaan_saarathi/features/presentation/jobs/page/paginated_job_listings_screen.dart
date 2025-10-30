import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/jobs_search_results.dart'
    as search_entities;
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/jobs/repository.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/active_filters_widget.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/widgets/job_card.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/utils.dart';

class PaginatedJobListingsScreen extends ConsumerStatefulWidget {
  const PaginatedJobListingsScreen({super.key});

  @override
  ConsumerState<PaginatedJobListingsScreen> createState() =>
      _PaginatedJobListingsScreenState();
}

class _SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SearchBarHeaderDelegate({
    required this.child,
    required this.height,
  });

  final Widget child;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SearchBarHeaderDelegate oldDelegate) {
    return true;
  }
}

class _PaginatedJobListingsScreenState
    extends ConsumerState<PaginatedJobListingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  final ScrollController _scrollController = ScrollController();
  final String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    Future.delayed(Duration(seconds: 1), () {
      _initialLoad();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _initialLoad() {
    final searchParams = _buildSearchParams();
    ref.read(searchJobsProvider.notifier).searchJobs(searchParams);
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        activeFilters: ref.read(filtersProvider),
        onFiltersChanged: (filters) {
          ref.read(filtersProvider.notifier).setAll(filters);
          _performSearch();
        },
      ),
    );
  }

  void _performSearch() {
    final searchParams = _buildSearchParams();
    ref.read(searchJobsProvider.notifier).searchJobs(searchParams);
  }

  void _loadMore() {
    final searchState = ref.read(searchJobsProvider);
    final canLoadMore = searchState.valueOrNull?.hasMore ?? false;
    final isLoadingMore = searchState.valueOrNull?.isLoadingMore ?? false;

    if (!isLoadingMore && canLoadMore) {
      ref.read(searchJobsProvider.notifier).loadNextPage();
    }
  }

  JobSearchDTO _buildSearchParams() {
    final filters = ref.read(filtersProvider);
    final keyword = filters['position'] ?? 
                  (_searchController.text.trim().isNotEmpty ? _searchController.text.trim() : '');
    
    return JobSearchDTO(
      keyword: keyword,
      country: filters['country'],
      minSalary: filters['salaryMin'] != null ? double.tryParse(filters['salaryMin']) : null,
      maxSalary: filters['salaryMax'] != null ? double.tryParse(filters['salaryMax']) : null,
    );
  }

  String _activeSearchResultsCount(
      AsyncValue<search_entities.PaginatedJobsSearchResults?> searchState) {
    return searchState.when(
      data: (results) => results?.total.toString() ?? '0',
      loading: () => '...',
      error: (_, __) => '0',
    );
  }

  bool _hasAnyResults(
      AsyncValue<search_entities.PaginatedJobsSearchResults?> searchState) {
    return searchState.when(
      data: (results) => results?.data.isNotEmpty ?? false,
      loading: () => false,
      error: (_, __) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchJobsProvider);
    final filters = ref.watch(filtersProvider);
    final providerQuery = _searchController.text.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 85,
            floating: false,
            leading: const SizedBox.shrink(),
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 0,
            collapsedHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryDarkColor
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: kHorizontalMargin, vertical: kVerticalMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Find Your Dream Job',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Discover opportunities that match your skills',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sticky Search Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarHeaderDelegate(
              height: 80,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search jobs...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          hintStyle: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                        onPressed: _showFilterModal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Active Filters (scrolls with content)
          if (filters.isNotEmpty || providerQuery.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ActiveFiltersWidget(
                  activeFilters: filters,
                  searchQuery: providerQuery,
                  onClearAll: () {
                    ref.read(filtersProvider.notifier).clear();
                    _searchController.clear();
                    _performSearch();
                  },
                  onRemoveFilter: (key) {
                    ref.read(filtersProvider.notifier).remove(key);
                    _performSearch();
                  },
                  onClearSearch: () {
                    _searchController.clear();
                    _performSearch();
                  },
                ),
              ),
            ),

          // Job Results Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_activeSearchResultsCount(searchState)} Jobs Found',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  if (_hasAnyResults(searchState))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Updated',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Job Listings
          searchState.when(
            data: (results) {
              if (results == null || results.data.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No jobs found')),
                );
              }
              
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= results.data.length) {
                      if (!results.hasMore) return null;
                      _loadMore();
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    
                    final job = results.data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: JobCard(job: job),
                    );
                  },
                  childCount: results.data.length + (results.hasMore ? 1 : 0),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
