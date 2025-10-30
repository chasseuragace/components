// lib/features/Applicaitons/presentation/pages/list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/shared/custom_appbar.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_pagination_wrapper.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/page/applications_tabbed_view.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/widget/empty_application_widget.dart';
import 'detail_by_id.dart';

class ApplicaitonsListPage extends ConsumerStatefulWidget {
  const ApplicaitonsListPage({super.key});

  @override
  _ApplicaitonsListPageState createState() => _ApplicaitonsListPageState();
}

class _ApplicaitonsListPageState extends ConsumerState<ApplicaitonsListPage> {
  BuildContext? barrierContext;

  @override
  Widget build(BuildContext context) {
    return ApplicationsTabbedView();
    // Using the new family provider with null status to get all applications
    final applicationsAsync = ref.watch(applicationsListProvider(null));
    
    // Set up delete listener
    listenToDeleteApplicaitonsAction(context);

    return Scaffold(
      appBar: SarathiAppBar(
        title: const Text("Applications List"),
      ),
      body: applicationsAsync.when(
        data: (wrapper) {
          if (wrapper.items.isEmpty) {
            return EmptyApplicationsState(
              onFindJobs: () {
                // Implement find jobs logic here
              },
            );
          }
          
          return RefreshIndicator(
            onRefresh: () => ref.refresh(applicationsListProvider(null).future),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: wrapper.items.length,
              itemBuilder: (context, index) {
                final item = wrapper.items[index];
                return ListTile(
                  title: Text(item.jobPosting?.title ?? 'Application ${item.id}'),
                  subtitle: Text('Status: ${item.status.toString().split('.').last}'),
                  onTap: () {
                    // Set the selected application ID
                    ref.read(selectedApplicationIdProvider.notifier).state = item.id;
                    // Navigate to detail page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ApplicationDetailPage(),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(applicationsListProvider(null)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context, ref);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void listenToDeleteApplicaitonsAction(BuildContext context) {
    ref.listen<AsyncValue>(deleteApplicaitonsProvider, (previous, next) {
      if (next.isLoading) {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) {
            barrierContext = context;
            return Container(
              color: Colors.black38,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        );
      } else if (previous?.isLoading == true) {
        // Close the loading dialog if it's open
        if (barrierContext != null && Navigator.canPop(barrierContext!)) {
          Navigator.of(barrierContext!).pop();
        }
        
        if (next.hasError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: ${next.error}')),
          );
        } else if (next.hasValue) {
          // Show success message and refresh the applications list
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully deleted')),
          );
          ref.invalidate(applicationsListProvider);
        }
      }
    });
  }

  // TODO: Implement listeners for other actions
  // void listenToAddApplicaitonsAction(BuildContext context) {
  //   ref.listen<AsyncValue>(addApplicaitonsProvider, (previous, next) {
  //     // Implementation similar to listenToDeleteApplicaitonsAction
  //   });
  // }

  // void listenToUpdateApplicaitonsAction(BuildContext context) {
  //   ref.listen<AsyncValue>(updateApplicaitonsProvider, (previous, next) {
  //     // Implementation similar to listenToDeleteApplicaitonsAction
  //   });
  // }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    // Implementation remains the same
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, ApplicaitonsEntity item) {
    // Implementation remains the same
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, String itemId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (result == true) {
      try {
        await ref.read(deleteApplicaitonsProvider.notifier).delete(itemId);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting item: $e')),
          );
        }
      }
    }
  }
}
