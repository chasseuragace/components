import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/page/job_listings_screen.dart';

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
