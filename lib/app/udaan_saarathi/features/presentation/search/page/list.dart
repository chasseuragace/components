// lib/features/Search/presentation/pages/list.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/search/search_params.dart';
import '../../../domain/entities/search/entity.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../utils/size_config.dart';
import '../providers/providers.dart';

class SearchListPage extends ConsumerStatefulWidget {
  const SearchListPage({super.key});

  @override
  _SearchListPageState createState() => _SearchListPageState();
}

class _SearchListPageState extends ConsumerState<SearchListPage> {
  BuildContext? barrierContext;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;
  Timer? _scrollDebounceTimer;
  String? _currentKeyword;
  int _currentPage = 1;
  final int _limit = 3; // Smaller limit for testing pagination
  String? _sortBy;
  String? _sortOrder;
  String _lastSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    _scrollDebounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    // Check if user has scrolled near the bottom (within 200 pixels)
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }

    // Cancel any pending load more operations
    _scrollDebounceTimer?.cancel();
    
    // Schedule a new load more operation with a small delay
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        ref.read(searchAgenciesProvider.notifier).loadMore();
      }
    });
  }

  void _onSearchChanged() {
    final currentQuery = _searchController.text.trim();
    
    // Only proceed if the text has actually changed
    if (currentQuery == _lastSearchQuery) return;
    
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _lastSearchQuery = currentQuery;
      if (mounted) {
        _performSearch();
      }
    });
  }

  void _performSearch() {
    final keyword = _searchController.text.trim();
    
    // Don't make API call if search text is empty
    if (keyword.isEmpty) {
      _currentKeyword = null;
      _currentPage = 1;
      // Reset to empty state
      ref.read(searchAgenciesProvider.notifier).search(
        SearchParams(page: 1, limit: _limit),
      );
      return;
    }
    
    _currentKeyword = keyword;
    _currentPage = 1;
    
    final params = SearchParams(
      keyword: _currentKeyword,
      page: _currentPage,
      limit: _limit,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );
    
    ref.read(searchAgenciesProvider.notifier).search(params);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentSortBy: _sortBy,
        currentSortOrder: _sortOrder,
        onApply: (sortBy, sortOrder) {
          setState(() {
            _sortBy = sortBy;
            _sortOrder = sortOrder;
          });
          // Apply filters to current search if keyword exists
          if (_currentKeyword != null && _currentKeyword!.isNotEmpty) {
            _performSearch();
          }
        },
        onReset: () {
          setState(() {
            _sortBy = null;
            _sortOrder = null;
          });
          // Re-apply search with reset filters if keyword exists
          if (_currentKeyword != null && _currentKeyword!.isNotEmpty) {
            _performSearch();
          }
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchAgenciesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Agencies'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
            tooltip: 'Filters',
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: kHorizontalMargin, vertical: kVerticalMargin),
        child: Column(
          children: [
            // Search Bar
            Container(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    return TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search agencies by name, location, specializations...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        suffixIcon: value.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _currentKeyword = null;
                                  _currentPage = 1;
                                  _lastSearchQuery = '';
                                  // Reset to empty state without API call
                                  ref.read(searchAgenciesProvider.notifier).search(
                                    SearchParams(page: 1, limit: _limit),
                                  );
                                },
                              )
                            : null,
                        prefixIconConstraints:
                            BoxConstraints(minWidth: 0, minHeight: 0),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: kVerticalMargin),
            Expanded(
              child: searchState.when(
              data: (result) {
                if (result.data.isEmpty && _currentKeyword == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Enter a keyword to search for agencies',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                
                if (result.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No agencies found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Found ${result.total} agencies',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: result.data.length + (result.page < result.totalPages ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show loading indicator at the bottom when loading more
                          if (index == result.data.length) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final agency = result.data[index];
                          return AgencyCard(agency: agency);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Page ${result.page} of ${result.totalPages}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error: ${error.toString()}',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentKeyword != null) {
                          _performSearch();
                        }
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

// Filter Bottom Sheet
class FilterBottomSheet extends StatefulWidget {
  final String? currentSortBy;
  final String? currentSortOrder;
  final Function(String?, String?) onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.currentSortBy,
    required this.currentSortOrder,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _tempSortBy;
  late String? _tempSortOrder;

  @override
  void initState() {
    super.initState();
    _tempSortBy = widget.currentSortBy;
    _tempSortOrder = widget.currentSortOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _tempSortBy = null;
                          _tempSortOrder = null;
                        });
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filter Options
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort By Section
                  Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildRadioOption(
                    'Name',
                    'name',
                    _tempSortBy,
                    (value) => setState(() => _tempSortBy = value),
                  ),
                  _buildRadioOption(
                    'Country',
                    'country',
                    _tempSortBy,
                    (value) => setState(() => _tempSortBy = value),
                  ),
                  _buildRadioOption(
                    'City',
                    'city',
                    _tempSortBy,
                    (value) => setState(() => _tempSortBy = value),
                  ),
                  _buildRadioOption(
                    'Created Date',
                    'created_at',
                    _tempSortBy,
                    (value) => setState(() => _tempSortBy = value),
                  ),
                  SizedBox(height: 24),
                  // Sort Order Section
                  Text(
                    'Sort Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildRadioOption(
                    'Ascending',
                    'asc',
                    _tempSortOrder,
                    (value) => setState(() => _tempSortOrder = value),
                  ),
                  _buildRadioOption(
                    'Descending',
                    'desc',
                    _tempSortOrder,
                    (value) => setState(() => _tempSortOrder = value),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Apply Button
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onReset();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_tempSortBy, _tempSortOrder);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
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

  Widget _buildRadioOption(
    String label,
    String value,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    final isSelected = selectedValue == value;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primaryColor : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// Agency Card styled similar to ManpowerCard
class AgencyCard extends StatelessWidget {
  final SearchEntity agency;

  const AgencyCard({super.key, required this.agency});

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Avatar and Basic Info
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.lightBlueColor,
                          AppColors.primaryDarkColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: agency.logoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              agency.logoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    _getInitials(agency.name),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              _getInitials(agency.name),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                  ),
                  if (agency.isActive)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(width: kHorizontalMargin),
              // Agency Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agency.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: kVerticalMargin / 4),
                    if (agency.city != null || agency.country != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: kHorizontalMargin / 4),
                          Text(
                            [agency.city, agency.country]
                                .where((e) => e != null)
                                .join(', '),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: kVerticalMargin),

          // Description
          if (agency.description != null && agency.description!.isNotEmpty)
            Text(
              agency.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (agency.description != null && agency.description!.isNotEmpty)
            SizedBox(height: kVerticalMargin),

          // Specializations
          if (agency.specializations != null && agency.specializations!.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...agency.specializations!.take(3).map((spec) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      spec,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
                if (agency.specializations!.length > 3)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '+${agency.specializations!.length - 3} more',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          if (agency.specializations != null && agency.specializations!.isNotEmpty)
            SizedBox(height: kVerticalMargin * 1.2),

          // Stats and Action Row
          Row(
            children: [
              // Stats
              Expanded(
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.work,
                            size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          '${agency.jobPostingCount} jobs',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (agency.licenseNumber.isNotEmpty) ...[
                      SizedBox(width: kHorizontalMargin),
                      Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            agency.licenseNumber,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: kHorizontalMargin / 2),
              // Action Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to agency detail
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Profile',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
