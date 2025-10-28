import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/jobs_search_results.dart'
    as search_entities;
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/jobs/repository.dart';
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

// Active Filters Widget
class ActiveFiltersWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final String searchQuery;
  final VoidCallback onClearAll;
  final Function(String) onRemoveFilter;
  final VoidCallback onClearSearch;

  const ActiveFiltersWidget({
    super.key,
    required this.activeFilters,
    required this.searchQuery,
    required this.onClearAll,
    required this.onRemoveFilter,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Filters',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary2,
              ),
            ),
            GestureDetector(
              onTap: onClearAll,
              child: const Text(
                'Clear All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (searchQuery.isNotEmpty)
              FilterChip(
                label: Text('Search: $searchQuery'),
                onDeleted: onClearSearch,
                onSelected: (value) {},
                deleteIcon: const Icon(Icons.close, size: 16),
              ),
            ...activeFilters.entries.map((entry) {
              String valueText;
              if (entry.key == 'salaryRange' && entry.value is Map) {
                final sr = entry.value as Map;
                final min = (sr['min'] as num?)?.round();
                final max = (sr['max'] as num?)?.round();
                valueText = 'Rs ${min ?? '-'} - Rs ${max ?? '-'}';
              } else {
                valueText = entry.value.toString();
              }
              return FilterChip(
                onSelected: (value) {},
                label: Text(
                  '${_getFilterDisplayName(entry.key)}: $valueText',
                ),
                onDeleted: () => onRemoveFilter(entry.key),
                deleteIcon: const Icon(Icons.close, size: 16),
              );
            }),
          ],
        ),
      ],
    );
  }

  String _getFilterDisplayName(String key) {
    switch (key) {
      case 'country':
        return 'Country';
      case 'position':
        return 'Position';
      case 'jobType':
        return 'Job Type';
      case 'experience':
        return 'Experience';
      case 'salaryRange':
        return 'Salary';
      case 'isRemote':
        return 'Remote';
      case 'isFeatured':
        return 'Featured';
      default:
        return key;
    }
  }
}

// Empty State Widget
class EmptyStateWidget extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  const EmptyStateWidget({
    super.key,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.search_off,
              size: 40,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            hasActiveFilters ? 'No jobs match your filters' : 'No jobs found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilters
                ? 'Try adjusting your search criteria or filters'
                : 'Check back later for new opportunities',
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onClearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Clear All Filters'),
            ),
          ],
        ],
      ),
    );
  }
}

// Filter Bottom Sheet
class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheet({
    super.key,
    required this.activeFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _tempFilters;

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.activeFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Jobs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _tempFilters.clear();
                    });
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection('Country', 'country', [
                    'Qatar',
                    'Malaysia',
                    'Saudi Arabia',
                    'UAE',
                    'Kuwait',
                  ]),
                  _buildFilterSection('Sort by', 'sortBy', [
                    'Posted at',
                    'Salary',
                    'Relevance',
                  ]),
                  _buildFilterSection('Order by', 'order', [
                    'Ascending',
                    'Descending',
                  ]),
                  // _buildFilterSection('Position', 'position', [
                  //   'Developer',
                  //   'Designer',
                  //   'Manager',
                  //   'Analyst',
                  //   'Specialist',
                  // ]),
                  // _buildFilterSection('Job Type', 'jobType', [
                  //   'Full Time',
                  //   'Part Time',
                  //   'Contract',
                  //   'Freelance',
                  // ]),
                  // _buildFilterSection('Experience Level', 'experience', [
                  //   '1-2',
                  //   '2-3',
                  //   '3-5',
                  //   '5+',
                  // ]),
                  // _buildFilterSection('Currency', 'currency', [
                  //   'NPR',
                  //   'USD',
                  // ]),
                  // Salary Range (NPR)
                  const SizedBox(height: 8),
                  const Text(
                    'Salary Range (NPR)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFDC2626).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Minimum',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            Builder(builder: (context) {
                              final sr = _tempFilters['salaryRange']
                                  as Map<String, dynamic>?;
                              final min =
                                  (sr?['min'] as num?)?.toDouble() ?? 1000.0;
                              return Text(
                                'Rs ${min.round()}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFDC2626),
                                ),
                              );
                            }),
                          ],
                        ),
                        Container(
                            width: 1,
                            height: 40,
                            color: const Color(0xFFE2E8F0)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Maximum',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            Builder(builder: (context) {
                              final sr = _tempFilters['salaryRange']
                                  as Map<String, dynamic>?;
                              final max =
                                  (sr?['max'] as num?)?.toDouble() ?? 999999.0;
                              return Text(
                                'Rs ${max.round()}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFDC2626),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Builder(builder: (context) {
                    final sr =
                        _tempFilters['salaryRange'] as Map<String, dynamic>?;
                    final double currentMin =
                        (sr?['min'] as num?)?.toDouble() ?? 1000.0;
                    final double currentMax =
                        (sr?['max'] as num?)?.toDouble() ?? 999999.0;
                    return RangeSlider(
                      values: RangeValues(currentMin, currentMax),
                      min: 1000,
                      max: 999999,
                      divisions: 48,
                      activeColor: const Color(0xFFDC2626),
                      inactiveColor: const Color(0xFFE2E8F0),
                      labels: RangeLabels(
                        'Rs ${currentMin.round()}',
                        'Rs ${currentMax.round()}',
                      ),
                      onChanged: (values) {
                        setState(() {
                          _tempFilters['salaryRange'] = {
                            'min': values.start,
                            'max': values.end,
                          };
                        });
                      },
                    );
                  }),
                  // _buildBooleanFilterSection('Remote Work', 'isRemote'),
                  // _buildBooleanFilterSection('Featured Jobs', 'isFeatured'),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFiltersChanged(_tempFilters);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, String key, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = _tempFilters[key] == option;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _tempFilters.remove(key);
                  } else {
                    _tempFilters[key] = option;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBooleanFilterSection(String title, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary2,
              ),
            ),
            Switch(
              value: _tempFilters[key] == true,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _tempFilters[key] = true;
                  } else {
                    _tempFilters.remove(key);
                  }
                });
              },
              activeColor: const Color(0xFF3B82F6),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
