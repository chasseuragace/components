import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/providers/providers.dart';

class ApplicationsTabbedView extends ConsumerStatefulWidget {
  final String? initialTab;
  
  const ApplicationsTabbedView({
    super.key,
    this.initialTab,
  });
  
  // Helper method to create a route with initial tab
  static Route<dynamic> route({String? initialTab}) {
    return MaterialPageRoute(
      builder: (context) => ApplicationsTabbedView(initialTab: initialTab),
    );
  }

  @override
  ConsumerState<ApplicationsTabbedView> createState() => _ApplicationsTabbedViewState();
}

class _ApplicationsTabbedViewState extends ConsumerState<ApplicationsTabbedView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _tabs = [
    'All',
    'Applied',
    'Shortlisted',
    'Interview',
    'Selected',
    'Rejected',
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    // Set initial tab if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialTab != null) {
        final index = _getTabIndex(widget.initialTab!);
        if (index != -1) {
          _tabController.animateTo(index);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          final status = _getStatusFromTab(tab);
          return ApplicationsListTab(status: status);
        }).toList(),
      ),
    );
  }

  int _getTabIndex(String tabName) {
    final lowerTabName = tabName.toLowerCase();
    for (int i = 0; i < _tabs.length; i++) {
      if (_tabs[i].toLowerCase() == lowerTabName) {
        return i;
      }
    }
    return -1; // Not found
  }

  String? _getStatusFromTab(String tab) {
    switch (tab.toLowerCase()) {
      case 'applied':
        return 'applied';
      case 'shortlisted':
        return 'shortlisted';
      case 'interview':
        return 'interview_scheduled';
      case 'selected':
        return 'interview_passed';
      case 'rejected':
        return 'interview_failed';
      default:
        return null; // 'All' tab
    }
  }
}

class ApplicationsListTab extends ConsumerWidget {
  final String? status;
  
  const ApplicationsListTab({
    super.key,
    this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(applicationsListProvider(status));
    
    return applicationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.refresh(applicationsListProvider(status)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (wrapper) {
        if (wrapper.items.isEmpty) {
          return const Center(
            child: Text(
              'No applications found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Add debug log when building the list
        debugPrint('Building list with ${wrapper.items.length} items, hasMoreToLoad: ${wrapper.hasMoreToLoad}');
        
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;
              final shouldLoadMore = metrics.pixels >= metrics.maxScrollExtent && 
                                  !metrics.outOfRange && 
                                  wrapper.hasMoreToLoad;
              
              debugPrint('ScrollEndNotification - ' 
                        'pixels: ${metrics.pixels}, '
                        'maxScrollExtent: ${metrics.maxScrollExtent}, '
                        'outOfRange: ${metrics.outOfRange}, '
                        'hasMoreToLoad: ${wrapper.hasMoreToLoad}, '
                        'shouldLoadMore: $shouldLoadMore');
              
              if (shouldLoadMore) {
                debugPrint('Loading next page for status: $status');
                ref.read(applicationsListProvider(status).notifier)
                    .loadNextPage(status);
              }
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () {
              debugPrint('Refreshing list for status: $status');
              return ref.refresh(applicationsListProvider(status).future);
            },
            child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: wrapper.items.length + (wrapper.hasMoreToLoad ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom if there are more items to load
              if (index >= wrapper.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final application = wrapper.items[index];
              return SizedBox(
                height: 500,
                width: 500,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      application.jobPosting?.title ?? 'Application ${application.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${application.status.toString().split('.').last}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        if (application.appliedAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Applied: ${application.appliedAt.toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      // Navigate to application details
                      ref.read(selectedApplicationIdProvider.notifier).state = application.id;
                      // TODO: Uncomment and implement navigation when detail page is ready
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ApplicationDetailPage(applicationId: application.id),
                      //   ),
                      // );
                    },
                  ),
                ),
              );
            },
          ),
        ));
      }
    );
  }
}
