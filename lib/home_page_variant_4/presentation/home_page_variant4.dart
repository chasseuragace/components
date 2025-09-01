import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/job_card_widget.dart';
import './widgets/quick_search_widget.dart';
import 'widgets/analytics_card.dart';

class HomePageVariant4 extends StatefulWidget {
  const HomePageVariant4({super.key});

  @override
  State<HomePageVariant4> createState() => _HomePageVariant4State();
}

class _HomePageVariant4State extends State<HomePageVariant4>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int _currentTabIndex = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  final List<String> _bookmarkedJobs = [];

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "profile_image":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "preferences": {
      "job_titles": [
        "Software Engineer",
        "Frontend Developer",
        "Full Stack Developer",
      ],
      "locations": ["San Francisco", "Remote", "New York"],
      "salary_range": {"min": 80000, "max": 150000, "currency": "USD"},
      "employment_types": ["Full-time", "Contract"],
    },
  };

  // Mock analytics data
  final Map<String, dynamic> _analyticsData = {
    "applications_sent": 24,
    "profile_views": 156,
    "saved_jobs": 12,
    "applications_trend": 15.2,
    "profile_views_trend": -8.5,
    "saved_jobs_trend": 22.1,
  };

  // Mock job recommendations
  final List<Map<String, dynamic>> _jobRecommendations = [
    {
      "id": 1,
      "title": "Senior Frontend Developer",
      "company": {
        "name": "TechCorp Solutions",
        "logo":
            "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=150&h=150&fit=crop",
      },
      "location": "San Francisco, CA",
      "employment_type": "Full-time",
      "experience_level": "Senior",
      "salary_range": {"min": 120000, "max": 160000, "currency": "USD"},
      "posted_date": "2025-08-30T10:00:00Z",
      "description":
          "Join our dynamic team as a Senior Frontend Developer and help build cutting-edge web applications using React and modern JavaScript frameworks.",
    },
    {
      "id": 2,
      "title": "Full Stack Engineer",
      "company": {
        "name": "InnovateLab",
        "logo":
            "https://images.unsplash.com/photo-1549923746-c502d488b3ea?w=150&h=150&fit=crop",
      },
      "location": "Remote",
      "employment_type": "Full-time",
      "experience_level": "Mid-level",
      "salary_range": {"min": 90000, "max": 130000, "currency": "USD"},
      "posted_date": "2025-08-29T14:30:00Z",
      "description":
          "We're looking for a talented Full Stack Engineer to work on exciting projects using Node.js, React, and cloud technologies.",
    },
    {
      "id": 3,
      "title": "Software Engineer",
      "company": {
        "name": "DataFlow Systems",
        "logo":
            "https://images.unsplash.com/photo-1551434678-e076c223a692?w=150&h=150&fit=crop",
      },
      "location": "New York, NY",
      "employment_type": "Full-time",
      "experience_level": "Mid-level",
      "salary_range": {"min": 100000, "max": 140000, "currency": "USD"},
      "posted_date": "2025-08-28T09:15:00Z",
      "description":
          "Join our engineering team to build scalable data processing systems and work with cutting-edge technologies.",
    },
    {
      "id": 4,
      "title": "React Developer",
      "company": {
        "name": "WebCraft Studios",
        "logo":
            "https://images.unsplash.com/photo-1572021335469-31706a17aaef?w=150&h=150&fit=crop",
      },
      "location": "Austin, TX",
      "employment_type": "Contract",
      "experience_level": "Mid-level",
      "salary_range": {"min": 80000, "max": 110000, "currency": "USD"},
      "posted_date": "2025-08-27T16:45:00Z",
      "description":
          "Contract opportunity to work on innovative web applications using React, TypeScript, and modern development practices.",
    },
    {
      "id": 5,
      "title": "Frontend Engineer",
      "company": {
        "name": "CloudTech Inc",
        "logo":
            "https://images.unsplash.com/photo-1553484771-371a605b060b?w=150&h=150&fit=crop",
      },
      "location": "Seattle, WA",
      "employment_type": "Full-time",
      "experience_level": "Junior",
      "salary_range": {"min": 70000, "max": 95000, "currency": "USD"},
      "posted_date": "2025-08-26T11:20:00Z",
      "description":
          "Great opportunity for a junior developer to grow their skills while working on cloud-based applications and user interfaces.",
    },
  ];

  List<Map<String, dynamic>> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _filteredJobs = List.from(_jobRecommendations);
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreJobs();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);
  }

  Future<void> _loadMoreJobs() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    // Simulate loading more jobs
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() => _isLoadingMore = false);
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();

    // Simulate refresh
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      _filteredJobs = List.from(_jobRecommendations);
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredJobs = List.from(_jobRecommendations);
      } else {
        _filteredJobs = _jobRecommendations.where((job) {
          final title = (job['title'] as String).toLowerCase();
          final company =
              ((job['company'] as Map<String, dynamic>)['name'] as String)
                  .toLowerCase();
          final location = (job['location'] as String).toLowerCase();
          final searchLower = query.toLowerCase();

          return title.contains(searchLower) ||
              company.contains(searchLower) ||
              location.contains(searchLower);
        }).toList();
      }
    });
  }

  void _toggleBookmark(int jobId) {
    HapticFeedback.lightImpact();
    setState(() {
      final jobIdString = jobId.toString();
      if (_bookmarkedJobs.contains(jobIdString)) {
        _bookmarkedJobs.remove(jobIdString);
      } else {
        _bookmarkedJobs.add(jobIdString);
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Filter Jobs',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Filter options will be implemented here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetupPreferences() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setup Job Preferences'),
        content: const Text(
          'Set up your job preferences to get personalized recommendations based on your interests, location, and salary requirements.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to preferences setup
            },
            child: const Text('Setup Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: GreetingHeaderWidget(
                userName: _userData['name'] as String,
                profileImageUrl: _userData['profile_image'] as String,
                onNotificationTap: () {
                  HapticFeedback.lightImpact();
                  // Handle notification tap
                },
                onProfileTap: () {
                  HapticFeedback.lightImpact();
                  // Handle profile tap
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 2.h)),
            SliverToBoxAdapter(
              child: AnalyticsCardsWidget(
                applicationsSent: _analyticsData['applications_sent'] as int,
                profileViews: _analyticsData['profile_views'] as int,
                savedJobs: _analyticsData['saved_jobs'] as int,
                applicationsTrend:
                    _analyticsData['applications_trend'] as double,
                profileViewsTrend:
                    _analyticsData['profile_views_trend'] as double,
                savedJobsTrend: _analyticsData['saved_jobs_trend'] as double,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 3.h)),
            SliverToBoxAdapter(
              child: QuickSearchWidget(
                initialQuery: _searchQuery,
                onSearchChanged: _onSearchChanged,
                onFilterTap: _showFilterBottomSheet,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 2.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Text(
                      'Recommended for You',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_filteredJobs.length} jobs',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 1.h)),
            _isLoading
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: 40.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  )
                : _filteredJobs.isEmpty
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50.h,
                      child: EmptyStateWidget(
                        title: _searchQuery.isNotEmpty
                            ? 'No jobs found'
                            : 'No recommendations yet',
                        subtitle: _searchQuery.isNotEmpty
                            ? 'Try adjusting your search terms or filters to find more relevant jobs.'
                            : 'Set up your job preferences to get personalized recommendations tailored to your interests.',
                        buttonText: _searchQuery.isNotEmpty
                            ? 'Clear Search'
                            : 'Set up Preferences',
                        onButtonPressed: _searchQuery.isNotEmpty
                            ? () => _onSearchChanged('')
                            : _showSetupPreferences,
                        illustrationUrl:
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < _filteredJobs.length) {
                          final job = _filteredJobs[index];
                          final jobId = job['id'] as int;

                          return JobCardWidget(
                            jobData: job,
                            isBookmarked: _bookmarkedJobs.contains(
                              jobId.toString(),
                            ),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // Navigate to job details
                            },
                            onBookmark: () => _toggleBookmark(jobId),
                            onApply: () {
                              HapticFeedback.lightImpact();
                              // Handle job application
                            },
                            onShare: () {
                              HapticFeedback.lightImpact();
                              // Handle job sharing
                            },
                          );
                        } else if (_isLoadingMore) {
                          return Container(
                            padding: EdgeInsets.all(4.w),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                      childCount:
                          _filteredJobs.length + (_isLoadingMore ? 1 : 0),
                    ),
                  ),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(0, 'Dashboard', 'dashboard', true),
                _buildBottomNavItem(1, 'Search', 'search', false),
                _buildBottomNavItem(2, 'Bookmarks', 'bookmark_outline', false),
                _buildBottomNavItem(3, 'Profile', 'person_outline', false),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          _showFilterBottomSheet();
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: CustomIconWidget(
          iconName: 'search',
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavItem(
    int index,
    String label,
    String iconName,
    bool isActive,
  ) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _currentTabIndex = index);

          if (index != 0) {
            Navigator.pushNamed(context, '/job-dashboard-screen');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 2.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isActive ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: CustomIconWidget(
                  iconName: isActive && iconName == 'dashboard'
                      ? 'dashboard'
                      : iconName,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              SizedBox(height: 1.w),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
