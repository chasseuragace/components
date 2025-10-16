// lib/features/interviews/presentation/pages/list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/shared/custom_appbar.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/interviews/get_all.dart';

import '../../../domain/entities/interviews/entity.dart';
import '../providers/providers.dart';

class InterviewsListPage extends ConsumerStatefulWidget {
  const InterviewsListPage({super.key});

  @override
  _InterviewsListPageState createState() => _InterviewsListPageState();
}

class _InterviewsListPageState extends ConsumerState<InterviewsListPage> {
  BuildContext? barrierContext;

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(getAllInterviewsProvider);
    final p = ref.watch(interviewPaginaionProvider);
    listenToDeleteInterviewsAction(context);
    // TODO: Set up listeners for other actions
    // listenToAddInterviewsAction(context);
    // listenToUpdateInterviewsAction(context);
    return Scaffold(
      appBar: SarathiAppBar(
        title: Text('Interviews List'),
      ),
      body: paginationState.when(
        data: (pageData) {
          final items = pageData.items;
          final total = pageData.total;
          final limit = pageData.limit == 0 ? (p.take) : pageData.limit;
          final page = pageData.page == 0 ? (p.page) : pageData.page;
          final totalPages = (total <= 0 || limit <= 0)
              ? 1
              : ((total + limit - 1) / limit).floor();

          if (items.isEmpty) {
            return Center(child: Text('No items available'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(
                        item.posting?.postingTitle ?? 'Interview ${item.id}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(context, ref, item);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteConfirmation(context, ref, item.id);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Handle item tap, e.g., navigate to detail page
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Page $page of $totalPages • Total $total'),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: page <= 1
                              ? null
                              : () {
                                  ref
                                          .read(interviewPaginaionProvider.notifier)
                                          .state =
                                      Pagination(page: page - 1, take: limit);
                                  ref.invalidate(getAllInterviewsProvider);
                                },
                          child: const Text('Prev'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: page >= totalPages
                              ? null
                              : () {
                                  ref
                                          .read(interviewPaginaionProvider.notifier)
                                          .state =
                                      Pagination(page: page + 1, take: limit);
                                  ref.invalidate(getAllInterviewsProvider);
                                },
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context, ref);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void listenToDeleteInterviewsAction(BuildContext context) {
    ref.listen<AsyncValue>(deleteInterviewsProvider, (previous, next) {
      if (next.isLoading) {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) {
            barrierContext = context;
            return Container(
              color: Colors.black38,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        );
      } else if (previous?.isLoading == true && next.hasError) {
        Navigator.of(barrierContext!).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete: ${next.error}")),
        );
        Future.delayed(Duration(seconds: 5), () {
          ref.refresh(deleteInterviewsProvider);
        });
      } else if (previous?.isLoading == true && next.hasValue) {
        Navigator.of(barrierContext!).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully deleted")),
        );
        // Refresh the list after successful deletion
        ref.refresh(getAllInterviewsProvider);
      }
    });
  }

  // TODO: Implement listeners for other actions
  // void listenToAddInterviewsAction(BuildContext context) {
  //   ref.listen<AsyncValue>(addInterviewsProvider, (previous, next) {
  //     // Implementation similar to listenToDeleteInterviewsAction
  //   });
  // }

  // void listenToUpdateInterviewsAction(BuildContext context) {
  //   ref.listen<AsyncValue>(updateInterviewsProvider, (previous, next) {
  //     // Implementation similar to listenToDeleteInterviewsAction
  //   });
  // }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    // Implementation remains the same
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, InterviewsEntity item) {
    // Implementation remains the same
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, String itemId) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (result == true) {
      ref.read(deleteInterviewsProvider.notifier).delete(itemId);
    }
  }
}
