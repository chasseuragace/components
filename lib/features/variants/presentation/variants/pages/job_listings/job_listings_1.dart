import 'dart:async';

import 'package:flutter/material.dart';
import 'package:variant_dashboard/features/variants/presentation/widgets/job_card.dart';

class JobListings1 extends StatefulWidget {
  const JobListings1({super.key});

  @override
  State<JobListings1> createState() => _JobListings1State();
}

class _JobListings1State extends State<JobListings1> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _allJobs = [];
  List<Map<String, dynamic>> _filteredJobs = [];

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

      // Country filter
      if (_activeFilters['country'] != null &&
          _activeFilters['country'].isNotEmpty) {
        if (!job['location'].toLowerCase().contains(
          _activeFilters['country'].toLowerCase(),
        )) {
          return false;
        }
      }

      // Position filter
      if (_activeFilters['position'] != null &&
          _activeFilters['position'].isNotEmpty) {
        if (!job['title'].toLowerCase().contains(
          _activeFilters['position'].toLowerCase(),
        )) {
          return false;
        }
      }

      // Job type filter
      if (_activeFilters['jobType'] != null &&
          _activeFilters['jobType'].isNotEmpty) {
        if (job['type'] != _activeFilters['jobType']) {
          return false;
        }
      }

      // Experience filter
      if (_activeFilters['experience'] != null &&
          _activeFilters['experience'].isNotEmpty) {
        if (!job['experience'].contains(_activeFilters['experience'])) {
          return false;
        }
      }

      // Remote filter
      if (_activeFilters['isRemote'] != null) {
        if (job['isRemote'] != _activeFilters['isRemote']) {
          return false;
        }
      }

      // Featured filter
      if (_activeFilters['isFeatured'] != null) {
        if (job['isFeatured'] != _activeFilters['isFeatured']) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Find Your Dream Job',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Discover opportunities that match your skills',
                          style: TextStyle(
                            fontSize: 16,
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
          ),

          // Search and Filter Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar
                  SearchBarWidget(
                    controller: _searchController,
                    onFilterTap: _showFilterModal,
                  ),
                  const SizedBox(height: 16),

                  // Active Filters
                  if (_activeFilters.isNotEmpty || _searchQuery.isNotEmpty)
                    ActiveFiltersWidget(
                      activeFilters: _activeFilters,
                      searchQuery: _searchQuery,
                      onClearAll: _clearAllFilters,
                      onRemoveFilter: (key) {
                        setState(() {
                          _activeFilters.remove(key);
                          _applyFilters();
                        });
                      },
                    ),
                ],
              ),
            ),
          ),

          // Job Results Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredJobs.length} Jobs Found',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  if (_filteredJobs.isNotEmpty)
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _filteredJobs.isEmpty
                ? SliverToBoxAdapter(
                    child: EmptyStateWidget(
                      hasActiveFilters:
                          _activeFilters.isNotEmpty || _searchQuery.isNotEmpty,
                      onClearFilters: _clearAllFilters,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: JobCardWidget(job: _filteredJobs[index]),
                      );
                    }, childCount: _filteredJobs.length),
                  ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDummyJobs() {
    return [
      {
        'title': 'Senior Flutter Developer',
        'company': 'TechCorp Nepal',
        'location': 'Kathmandu, Nepal',
        'salary': 'NPR 80,000 - 120,000',
        'type': 'Full Time',
        'experience': '3-5 years',
        'posted': '2 days ago',
        'isRemote': true,
        'isFeatured': true,
        'companyLogo': 'T',
        'matchPercentage': 95,
        'gender': 'Any',
      },
      {
        'title': 'UI/UX Designer',
        'company': 'DesignStudio',
        'location': 'Pokhara, Nepal',
        'salary': 'NPR 60,000 - 90,000',
        'type': 'Full Time',
        'experience': '2-4 years',
        'posted': '1 day ago',
        'isRemote': false,
        'isFeatured': false,
        'companyLogo': 'D',
        'matchPercentage': 88,
        'gender': 'Any',
      },
      {
        'title': 'Backend Developer',
        'company': 'DevSolutions',
        'location': 'Lalitpur, Nepal',
        'salary': 'NPR 70,000 - 100,000',
        'type': 'Full Time',
        'experience': '2-3 years',
        'posted': '3 days ago',
        'isRemote': true,
        'isFeatured': false,
        'companyLogo': 'D',
        'matchPercentage': 82,
        'gender': 'Male',
      },
      {
        'title': 'Project Manager',
        'company': 'ManageCorp',
        'location': 'Kathmandu, Nepal',
        'salary': 'NPR 90,000 - 130,000',
        'type': 'Full Time',
        'experience': '5+ years',
        'posted': '1 week ago',
        'isRemote': false,
        'isFeatured': true,
        'companyLogo': 'M',
        'matchPercentage': 75,
        'gender': 'Female',
      },
      {
        'title': 'Data Scientist',
        'company': 'DataTech',
        'location': 'Bhaktapur, Nepal',
        'salary': 'NPR 85,000 - 115,000',
        'type': 'Part Time',
        'experience': '3-4 years',
        'posted': '4 days ago',
        'isRemote': true,
        'isFeatured': false,
        'companyLogo': 'D',
        'matchPercentage': 90,
        'gender': 'Any',
      },
      {
        'title': 'Marketing Specialist',
        'company': 'MarketPro',
        'location': 'Chitwan, Nepal',
        'salary': 'NPR 50,000 - 75,000',
        'type': 'Contract',
        'experience': '1-2 years',
        'posted': '5 days ago',
        'isRemote': false,
        'isFeatured': false,
        'companyLogo': 'M',
        'matchPercentage': 68,
        'gender': 'Female',
      },
    ];
  }
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
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
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

// Active Filters Widget
class ActiveFiltersWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final String searchQuery;
  final VoidCallback onClearAll;
  final Function(String) onRemoveFilter;

  const ActiveFiltersWidget({
    super.key,
    required this.activeFilters,
    required this.searchQuery,
    required this.onClearAll,
    required this.onRemoveFilter,
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
                color: Color(0xFF374151),
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
                onDeleted: () {
                  // Handle search clear
                },
                onSelected: (value) {},
                deleteIcon: const Icon(Icons.close, size: 16),
              ),
            ...activeFilters.entries.map((entry) {
              return FilterChip(
                onSelected: (value) {},
                label: Text(
                  '${_getFilterDisplayName(entry.key)}: ${entry.value}',
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
              color: Color(0xFF374151),
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
                      color: Color(0xFF3B82F6),
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
                    'Nepal',
                    'India',
                    'USA',
                    'Canada',
                    'Australia',
                  ]),
                  _buildFilterSection('Position', 'position', [
                    'Developer',
                    'Designer',
                    'Manager',
                    'Analyst',
                    'Specialist',
                  ]),
                  _buildFilterSection('Job Type', 'jobType', [
                    'Full Time',
                    'Part Time',
                    'Contract',
                    'Freelance',
                  ]),
                  _buildFilterSection('Experience Level', 'experience', [
                    '1-2',
                    '2-3',
                    '3-5',
                    '5+',
                  ]),
                  _buildBooleanFilterSection('Remote Work', 'isRemote'),
                  _buildBooleanFilterSection('Featured Jobs', 'isFeatured'),
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
                        borderRadius: BorderRadius.circular(12),
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
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
            color: Color(0xFF374151),
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
                color: Color(0xFF374151),
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
