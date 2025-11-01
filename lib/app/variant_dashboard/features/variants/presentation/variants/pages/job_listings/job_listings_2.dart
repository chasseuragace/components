import 'dart:async';

import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';

class JobListings2 extends StatefulWidget {
  const JobListings2({super.key});

  @override
  State<JobListings2> createState() => _JobListings2State();
}

class _JobListings2State extends State<JobListings2> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _allJobs = [];
  List<Map<String, dynamic>> _filteredJobs = [];
  String _sortBy = 'relevance';

  @override
  void initState() {
    super.initState();
    _allJobs = _getDummyJobs();
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
      setState(() {
        _searchQuery = _searchController.text;
        _applyFilters();
      });
    });
  }

  void _applyFilters() {
    _filteredJobs = _allJobs.where((job) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!job['title'].toLowerCase().contains(searchLower) &&
            !job['company'].toLowerCase().contains(searchLower) &&
            !job['location'].toLowerCase().contains(searchLower)) {
          return false;
        }
      }

      // Apply other filters
      if (_activeFilters['country'] != null &&
          _activeFilters['country'].isNotEmpty) {
        if (!job['location'].toLowerCase().contains(
              _activeFilters['country'].toLowerCase(),
            )) {
          return false;
        }
      }

      if (_activeFilters['position'] != null &&
          _activeFilters['position'].isNotEmpty) {
        if (!job['title'].toLowerCase().contains(
              _activeFilters['position'].toLowerCase(),
            )) {
          return false;
        }
      }

      if (_activeFilters['jobType'] != null &&
          _activeFilters['jobType'].isNotEmpty) {
        if (job['type'] != _activeFilters['jobType']) {
          return false;
        }
      }

      if (_activeFilters['experience'] != null &&
          _activeFilters['experience'].isNotEmpty) {
        if (!job['experience'].contains(_activeFilters['experience'])) {
          return false;
        }
      }

      if (_activeFilters['isRemote'] != null) {
        if (job['isRemote'] != _activeFilters['isRemote']) {
          return false;
        }
      }

      if (_activeFilters['isFeatured'] != null) {
        if (job['isFeatured'] != _activeFilters['isFeatured']) {
          return false;
        }
      }

      return true;
    }).toList();

    _applySorting();
  }

  void _applySorting() {
    switch (_sortBy) {
      case 'newest':
        _filteredJobs.sort(
          (a, b) => _getPostedDays(
            a['posted'],
          ).compareTo(_getPostedDays(b['posted'])),
        );
        break;
      case 'salary':
        _filteredJobs.sort(
          (a, b) => _getSalaryValue(
            b['salary'],
          ).compareTo(_getSalaryValue(a['salary'])),
        );
        break;
      case 'match':
        _filteredJobs.sort(
          (a, b) => b['matchPercentage'].compareTo(a['matchPercentage']),
        );
        break;
      default:
        _filteredJobs.sort((a, b) {
          if (a['isFeatured'] && !b['isFeatured']) return -1;
          if (!a['isFeatured'] && b['isFeatured']) return 1;
          return b['matchPercentage'].compareTo(a['matchPercentage']);
        });
    }
  }

  int _getPostedDays(String posted) {
    if (posted.contains('day')) return int.tryParse(posted.split(' ')[0]) ?? 0;
    if (posted.contains('week')) {
      return (int.tryParse(posted.split(' ')[0]) ?? 0) * 7;
    }
    return 0;
  }

  int _getSalaryValue(String salary) {
    final numbers = RegExp(
      r'\d+',
    ).allMatches(salary).map((m) => int.parse(m.group(0)!)).toList();
    return numbers.isNotEmpty
        ? numbers.reduce((a, b) => a + b) ~/ numbers.length
        : 0;
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetV2(
        activeFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SortBottomSheet(
        currentSort: _sortBy,
        onSortChanged: (sort) {
          setState(() {
            _sortBy = sort;
            _applySorting();
          });
        },
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
      _searchController.clear();
      _searchQuery = '';
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Job Search',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                // Search Bar
                SearchBarWidgetV2(
                  controller: _searchController,
                  onFilterTap: _showFilterModal,
                ),
                const SizedBox(height: 16),

                // Filter & Sort Row
                Row(
                  children: [
                    Expanded(
                      child:
                          _activeFilters.isNotEmpty || _searchQuery.isNotEmpty
                              ? ActiveFiltersWidgetV2(
                                  activeFilters: _activeFilters,
                                  searchQuery: _searchQuery,
                                  onClearAll: _clearAllFilters,
                                  onRemoveFilter: (key) {
                                    setState(() {
                                      _activeFilters.remove(key);
                                      _applyFilters();
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                    ),
                    GestureDetector(
                      onTap: _showSortModal,
                      child: Container(
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
                            const Icon(
                              Icons.sort,
                              size: 16,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getSortDisplayName(_sortBy),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary2,
                    ),
                    children: [
                      TextSpan(
                        text: '${_filteredJobs.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const TextSpan(text: ' jobs found'),
                    ],
                  ),
                ),
                if (_filteredJobs.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF059669),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Live',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Job Listings
          Expanded(
            child: _filteredJobs.isEmpty
                ? EmptyStateWidgetV2(
                    hasActiveFilters:
                        _activeFilters.isNotEmpty || _searchQuery.isNotEmpty,
                    onClearFilters: _clearAllFilters,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredJobs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return Container();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getSortDisplayName(String sort) {
    switch (sort) {
      case 'newest':
        return 'Newest';
      case 'salary':
        return 'Salary';
      case 'match':
        return 'Match';
      default:
        return 'Relevance';
    }
  }

  List<Map<String, dynamic>> _getDummyJobs() {
    return [
      {
        'title': 'Electrician',
        'company': 'Qatar Power Services',
        'location': 'Doha, Qatar',
        'salary': 'QAR 1,800 - 2,200',
        'type': 'Full Time',
        'experience': '2-3 years',
        'posted': '2 days ago',
        'isRemote': false,
        'isFeatured': true,
        'companyLogo': 'Q',
        'matchPercentage': 92,
        'gender': 'Male',
      },
      {
        'title': 'Plumber',
        'company': 'Dubai Facility Management',
        'location': 'Dubai, UAE',
        'salary': 'AED 1,500 - 2,000',
        'type': 'Full Time',
        'experience': '1-2 years',
        'posted': '1 day ago',
        'isRemote': false,
        'isFeatured': false,
        'companyLogo': 'D',
        'matchPercentage': 85,
        'gender': 'Male',
      },
      {
        'title': 'Construction Worker',
        'company': 'Saudi Build Co.',
        'location': 'Riyadh, Saudi Arabia',
        'salary': 'SAR 1,200 - 1,800',
        'type': 'Contract',
        'experience': 'No prior experience required',
        'posted': '3 days ago',
        'isRemote': false,
        'isFeatured': true,
        'companyLogo': 'S',
        'matchPercentage': 80,
        'gender': 'Male',
      },
      {
        'title': 'Driver',
        'company': 'Al Jazeera Transport',
        'location': 'Doha, Qatar',
        'salary': 'QAR 2,000 - 2,500',
        'type': 'Full Time',
        'experience': '2+ years with GCC License',
        'posted': '1 week ago',
        'isRemote': false,
        'isFeatured': true,
        'companyLogo': 'A',
        'matchPercentage': 88,
        'gender': 'Male',
      },
      {
        'title': 'Housekeeper',
        'company': 'Dubai Hospitality Group',
        'location': 'Dubai, UAE',
        'salary': 'AED 1,200 - 1,800',
        'type': 'Full Time',
        'experience': '1-2 years in hotels/residences',
        'posted': '4 days ago',
        'isRemote': false,
        'isFeatured': false,
        'companyLogo': 'H',
        'matchPercentage': 76,
        'gender': 'Female',
      },
      {
        'title': 'Cook',
        'company': 'Saudi Catering Services',
        'location': 'Jeddah, Saudi Arabia',
        'salary': 'SAR 1,800 - 2,200',
        'type': 'Full Time',
        'experience': '2-4 years in restaurant kitchen',
        'posted': '5 days ago',
        'isRemote': false,
        'isFeatured': false,
        'companyLogo': 'C',
        'matchPercentage': 83,
        'gender': 'Any',
      },
    ];
  }
}

// Search Bar Widget V2
class SearchBarWidgetV2 extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;

  const SearchBarWidgetV2({
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
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search for jobs, companies...',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1F2937).withOpacity(0.2),
                  blurRadius: 6,
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

// Active Filters Widget V2
class ActiveFiltersWidgetV2 extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final String searchQuery;
  final VoidCallback onClearAll;
  final Function(String) onRemoveFilter;

  const ActiveFiltersWidgetV2({
    super.key,
    required this.activeFilters,
    required this.searchQuery,
    required this.onClearAll,
    required this.onRemoveFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (searchQuery.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Search: $searchQuery',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ...activeFilters.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_getFilterDisplayName(entry.key)}: ${entry.value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => onRemoveFilter(entry.key),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (activeFilters.isNotEmpty || searchQuery.isNotEmpty)
            GestureDetector(
              onTap: onClearAll,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getFilterDisplayName(String key) {
    switch (key) {
      case 'country':
        return 'Country';
      case 'position':
        return 'Position';
      case 'jobType':
        return 'Type';
      case 'experience':
        return 'Experience';
      case 'isRemote':
        return 'Remote';
      case 'isFeatured':
        return 'Featured';
      default:
        return key;
    }
  }
}

// Empty State Widget V2
class EmptyStateWidgetV2 extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  const EmptyStateWidgetV2({
    super.key,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(
                Icons.work_outline,
                size: 48,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              hasActiveFilters ? 'No matching jobs' : 'No jobs available',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasActiveFilters
                  ? 'Try adjusting your filters to see more results'
                  : 'New opportunities will appear here soon',
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            if (hasActiveFilters) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onClearFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Sort Bottom Sheet
class SortBottomSheet extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {
        'key': 'relevance',
        'title': 'Relevance',
        'subtitle': 'Best match for you',
      },
      {
        'key': 'newest',
        'title': 'Date Posted',
        'subtitle': 'Most recent first',
      },
      {'key': 'salary', 'title': 'Salary', 'subtitle': 'Highest salary first'},
      {
        'key': 'match',
        'title': 'Match Score',
        'subtitle': 'Best match percentage',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...sortOptions.map((option) {
            final isSelected = currentSort == option['key'];
            return GestureDetector(
              onTap: () {
                onSortChanged(option['key'] as String);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF1F2937)
                                  : AppColors.textPrimary2,
                            ),
                          ),
                          Text(
                            option['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF059669),
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Filter Bottom Sheet V2
class FilterBottomSheetV2 extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetV2({
    super.key,
    required this.activeFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetV2> createState() => _FilterBottomSheetV2State();
}

class _FilterBottomSheetV2State extends State<FilterBottomSheetV2> {
  late Map<String, dynamic> _tempFilters;

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.activeFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _tempFilters.clear();
                        });
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSectionV2('Location', 'country', [
                    'Nepal',
                    'India',
                    'USA',
                    'Canada',
                    'Australia',
                  ]),
                  _buildFilterSectionV2('Job Role', 'position', [
                    'Developer',
                    'Designer',
                    'Manager',
                    'Analyst',
                    'Specialist',
                  ]),
                  _buildFilterSectionV2('Job Type', 'jobType', [
                    'Full Time',
                    'Part Time',
                    'Contract',
                    'Freelance',
                  ]),
                  _buildFilterSectionV2('Experience', 'experience', [
                    '1-2',
                    '2-3',
                    '3-5',
                    '5+',
                  ]),
                  _buildBooleanFilterSectionV2('Remote Work', 'isRemote'),
                  _buildBooleanFilterSectionV2('Featured Jobs', 'isFeatured'),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
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
                      backgroundColor: const Color(0xFF1F2937),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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

  Widget _buildFilterSectionV2(String title, String key, List<String> options) {
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
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1F2937)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
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

  Widget _buildBooleanFilterSectionV2(String title, String key) {
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
              activeColor: const Color(0xFF1F2937),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
