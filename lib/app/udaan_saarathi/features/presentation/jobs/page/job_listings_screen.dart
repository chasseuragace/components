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

class JobListingsScreen extends ConsumerStatefulWidget {
  const JobListingsScreen({super.key, required this.jobs});
  final List<JobsEntity> jobs;
  @override
  ConsumerState<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends ConsumerState<JobListingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  final String _searchQuery = '';
  final Map<String, dynamic> _activeFilters = {};
  List<JobsEntity> _allJobs = [];
  List<JobsEntity> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _allJobs = widget.jobs;
    _filteredJobs = _allJobs;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // push to provider
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
      _applyFilters();
      _triggerSearch();
    });
  }

  void _applyFilters() {
    final filters = ref.read(filtersProvider);
    final query = ref.read(searchQueryProvider);
    _filteredJobs = _allJobs.where((job) {
      // Search filter
      if (query.isNotEmpty) {
        final searchLower = query.toLowerCase();
        if (!job.postingTitle.toLowerCase().contains(searchLower) &&
            !job.employer.companyName.toLowerCase().contains(searchLower) &&
            !job.city.toLowerCase().contains(searchLower) &&
            !job.country.toLowerCase().contains(searchLower)) {
          return false;
        }
      }

      // Country filter
      if (filters['country'] != null && filters['country'].isNotEmpty) {
        if (!job.country.toLowerCase().contains(
              filters['country'].toLowerCase(),
            )) {
          return false;
        }
      }

      // Position filter
      if (filters['position'] != null && filters['position'].isNotEmpty) {
        if (!job.postingTitle.toLowerCase().contains(
              filters['position'].toLowerCase(),
            )) {
          return false;
        }
      }

      // Job type filter
      // if (_activeFilters['jobType'] != null &&
      //     _activeFilters['jobType'].isNotEmpty) {
      //   if (job['type'] != _activeFilters['jobType']) {
      //     return false;
      //   }
      // }

      // Experience filter
      if (filters['experience'] != null && filters['experience'].isNotEmpty) {
        if (!job.experienceRequirements.minYears
            .toString()
            .contains(filters['experience'])) {
          return false;
        }
      }

      // Salary range filter (expects Map {min: double, max: double} in NPR)
      if (filters['salaryRange'] != null) {
        final dynamic sr = filters['salaryRange'];
        final double min = (sr['min'] as num).toDouble();
        final double max = (sr['max'] as num).toDouble();

        bool matches = false;
        for (final position in job.positions) {
          final npr = _extractSalaryNpr(position.salary);
          if (npr != null && npr >= min && npr <= max) {
            matches = true;
            break;
          }
        }
        if (!matches) return false;
      }

      // Remote filter
      // if (_activeFilters['isRemote'] != null) {
      //   if (job.contract != _activeFilters['isRemote']) {
      //     return false;
      //   }
      // }

      // Featured filter
      // if (_activeFilters['isFeatured'] != null) {
      //   if (job['isFeatured'] != _activeFilters['isFeatured']) {
      //     return false;
      //   }
      // }

      return true;
    }).toList();
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
          _applyFilters();
          _triggerSearch();
        },
      ),
    );
  }

  void _clearAllFilters() {
    ref.read(filtersProvider.notifier).clear();
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    _applyFilters();
    // Clear remote search results when nothing to search
    ref.read(searchJobsProvider.notifier).clearResults();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchJobsProvider);
    final providerFilters = ref.watch(filtersProvider);
    final providerQuery = ref.watch(searchQueryProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
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
                      Text(
                        'Find Your Dream Job',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
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
              height: 100,
              child: SearchBarWidget(
                controller: _searchController,
                onFilterTap: _showFilterModal,
              ),
            ),
          ),

          // Active Filters (scrolls with content)
          if (providerFilters.isNotEmpty || providerQuery.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin),
                child: ActiveFiltersWidget(
                  activeFilters: providerFilters,
                  searchQuery: providerQuery,
                  onClearAll: _clearAllFilters,
                  onRemoveFilter: (key) {
                    ref.read(filtersProvider.notifier).remove(key);
                    _applyFilters();
                    _triggerSearch();
                  },
                  onClearSearch: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                    _applyFilters();
                    _triggerSearch();
                  },
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                      horizontal: kHorizontalMargin,
                      vertical: kVerticalMargin / 4)
                  .copyWith(top: kVerticalMargin),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Icon(
                        //   Icons.sort,
                        //   size: 16,
                        //   color: Color(0xFF6B7280),
                        // ),
                        // const SizedBox(width: 4),
                        Text(
                          "Plumber",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Job Results Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: kHorizontalMargin, vertical: 16),
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
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
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
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin),
            sliver: _buildResultSliver(searchState),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  // List<Map<String, dynamic>> _getDummyJobs() {
  //   return [
  //     {
  //       'title': 'Electrician',
  //       'company': 'Qatar Power Services',
  //       'location': 'Doha, Qatar',
  //       'salary': 'QAR 1,800 - 2,200',
  //       'type': 'Full Time',
  //       'experience': '2-3 years',
  //       'posted': '2 days ago',
  //       'isRemote': false,
  //       'isFeatured': true,
  //       'companyLogo': 'Q',
  //       'matchPercentage': 92,
  //       'gender': 'Male',
  //     },
  //     {
  //       'title': 'Plumber',
  //       'company': 'Dubai Facility Management',
  //       'location': 'Dubai, UAE',
  //       'salary': 'AED 1,500 - 2,000',
  //       'type': 'Full Time',
  //       'experience': '1-2 years',
  //       'posted': '1 day ago',
  //       'isRemote': false,
  //       'isFeatured': false,
  //       'companyLogo': 'D',
  //       'matchPercentage': 85,
  //       'gender': 'Male',
  //     },
  //     {
  //       'title': 'Construction Worker',
  //       'company': 'Saudi Build Co.',
  //       'location': 'Riyadh, Saudi Arabia',
  //       'salary': 'SAR 1,200 - 1,800',
  //       'type': 'Contract',
  //       'experience': 'No prior experience required',
  //       'posted': '3 days ago',
  //       'isRemote': false,
  //       'isFeatured': true,
  //       'companyLogo': 'S',
  //       'matchPercentage': 80,
  //       'gender': 'Male',
  //     },
  //     {
  //       'title': 'Driver',
  //       'company': 'Al Jazeera Transport',
  //       'location': 'Doha, Qatar',
  //       'salary': 'QAR 2,000 - 2,500',
  //       'type': 'Full Time',
  //       'experience': '2+ years with GCC License',
  //       'posted': '1 week ago',
  //       'isRemote': false,
  //       'isFeatured': true,
  //       'companyLogo': 'A',
  //       'matchPercentage': 88,
  //       'gender': 'Male',
  //     },
  //     {
  //       'title': 'Housekeeper',
  //       'company': 'Dubai Hospitality Group',
  //       'location': 'Dubai, UAE',
  //       'salary': 'AED 1,200 - 1,800',
  //       'type': 'Full Time',
  //       'experience': '1-2 years in hotels/residences',
  //       'posted': '4 days ago',
  //       'isRemote': false,
  //       'isFeatured': false,
  //       'companyLogo': 'H',
  //       'matchPercentage': 76,
  //       'gender': 'Female',
  //     },
  //     {
  //       'title': 'Cook',
  //       'company': 'Saudi Catering Services',
  //       'location': 'Jeddah, Saudi Arabia',
  //       'salary': 'SAR 1,800 - 2,200',
  //       'type': 'Full Time',
  //       'experience': '2-4 years in restaurant kitchen',
  //       'posted': '5 days ago',
  //       'isRemote': false,
  //       'isFeatured': false,
  //       'companyLogo': 'C',
  //       'matchPercentage': 83,
  //       'gender': 'Any',
  //     },
  //   ];
  // }
}

// Search Bar Widget
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search jobs, companies, locations...',
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}

// Helpers for remote search integration
extension _RemoteSearchHelpers on _JobListingsScreenState {
  void _triggerSearch() {
    final filters = ref.read(filtersProvider);
    final query = ref.read(searchQueryProvider);
    final hasSearch = query.trim().isNotEmpty ||
        (filters['country'] != null &&
            (filters['country'] as String).trim().isNotEmpty) ||
        (filters['salaryRange'] != null) ||
        (filters['currency'] != null &&
            (filters['currency'] as String).trim().isNotEmpty);

    if (!hasSearch) {
      ref.read(searchJobsProvider.notifier).clearResults();
      return;
    }

    final sr = filters['salaryRange'] as Map<String, dynamic>?;
    // Map UI values to API values for sort and order
    final String? sortByUi = filters['sortBy'] as String?;
    final String? orderUi = filters['order'] as String?;
    final String? sortBy = sortByUi == null
        ? null
        : (sortByUi == 'Posted at'
            ? 'posted_at'
            : (sortByUi == 'Salary'
                ? 'salary'
                : (sortByUi == 'Relevance' ? 'relevance' : null)));
    final String? order = orderUi == null
        ? null
        : (orderUi == 'Ascending'
            ? 'asc'
            : (orderUi == 'Descending' ? 'desc' : null));
    final dto = JobSearchDTO(
      keyword: query.trim().isNotEmpty ? query.trim() : null,
      country: filters['country'],
      minSalary: sr != null ? (sr['min'] as num?)?.toDouble() : null,
      maxSalary: sr != null ? (sr['max'] as num?)?.toDouble() : null,
      currency: filters['currency'] as String?,
      page: 1,
      limit: 10,
      sortBy: sortBy,
      order: order,
    );
    print(dto.currency);
    ref.read(searchJobsProvider.notifier).searchJobs(dto);
  }

  int _activeSearchResultsCount(
      AsyncValue<search_entities.PaginatedJobsSearchResults?> searchState) {
    return searchState.when(
      data: (data) => data?.data.length ?? _filteredJobs.length,
      loading: () => _filteredJobs.length,
      error: (_, __) => 0,
    );
  }

  bool _hasAnyResults(
      AsyncValue<search_entities.PaginatedJobsSearchResults?> searchState) {
    return searchState.when(
      data: (data) =>
          (data?.data.isNotEmpty ?? false) || _filteredJobs.isNotEmpty,
      loading: () => _filteredJobs.isNotEmpty,
      error: (_, __) => false,
    );
  }

  // Extract a salary amount in NPR from a Position's Salary entity
  double? _extractSalaryNpr(Salary salary) {
    if (salary.currency.toUpperCase() == 'NPR') {
      return salary.monthlyAmount;
    }
    try {
      final match =
          salary.converted.firstWhere((c) => c.currency.toUpperCase() == 'NPR');
      return match.amount;
    } catch (_) {
      return null;
    }
  }

  SliverChildDelegate _buildLocalListDelegate() {
    return SliverChildBuilderDelegate((context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: JobCard(job: _filteredJobs[index]),
      );
    }, childCount: _filteredJobs.length);
  }

  Widget _buildError(Object error) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildSearchCard(search_entities.JobsSearchResults job) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF1F5F9),
                child: Text(
                  job.employer.companyName.isNotEmpty
                      ? job.employer.companyName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.postingTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.employer.companyName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Text(
                job.city,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.work_outline,
                        size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      job.positions.isNotEmpty
                          ? job.positions.first.vacancies.total.toString()
                          : 'N/A',
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule,
                        size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      job.postingDateAd.toLocal().toString().split(' ').first,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Salary',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    job.positions.isNotEmpty
                        ? '${job.positions.first.salary.currency} ${job.positions.first.salary.monthlyAmount}'
                        : '—',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryDarkColor,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultSliver(
      AsyncValue<search_entities.PaginatedJobsSearchResults?> searchState) {
    return searchState.when(
      loading: () {
        // if (_filteredJobs.isEmpty) {
        //   return SliverToBoxAdapter(
        //     child: EmptyStateWidget(
        //       hasActiveFilters:
        //           _activeFilters.isNotEmpty || _searchQuery.isNotEmpty,
        //       onClearFilters: _clearAllFilters,
        //     ),
        //   );
        // }
        // return SliverList(delegate: _buildLocalListDelegate());
        return SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()));
      },
      error: (err, _) => SliverToBoxAdapter(child: _buildError(err)),
      data: (data) {
        if (data == null) {
          if (_filteredJobs.isEmpty) {
            return SliverToBoxAdapter(
              child: EmptyStateWidget(
                hasActiveFilters:
                    _activeFilters.isNotEmpty || _searchQuery.isNotEmpty,
                onClearFilters: _clearAllFilters,
              ),
            );
          }
          return SliverList(delegate: _buildLocalListDelegate());
        }

        final results = data.data;
        if (results.isEmpty) {
          return SliverToBoxAdapter(
            child: EmptyStateWidget(
              hasActiveFilters: true,
              onClearFilters: _clearAllFilters,
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = results[index];
              return Padding(
                padding: EdgeInsets.only(bottom: kVerticalMargin),
                child: JobCard(
                  job: item,
                ),
              );
            },
            childCount: results.length,
          ),
        );
      },
    );
  }
}

// Sticky Search Bar Header Delegate
class _SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _SearchBarHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SearchBarHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
