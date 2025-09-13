// lib/features/Preferences/presentation/pages/list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/preferences/entity.dart';
import '../providers/providers.dart';

class PreferencesListPage extends ConsumerStatefulWidget {
  const PreferencesListPage({super.key});

  @override
  _PreferencesListPageState createState() => _PreferencesListPageState();
}

class _PreferencesListPageState extends ConsumerState<PreferencesListPage> {
  BuildContext? barrierContext;



  @override
  Widget build(BuildContext context) {
    final PreferencesState = ref.watch(getAllPreferencesProvider);
      listenToDeletePreferencesAction(context);
      // TODO: Set up listeners for other actions
      // listenToAddPreferencesAction(context);
      // listenToUpdatePreferencesAction(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences List'),
      ),
      body: PreferencesState.when(
        data: (items) => items.isEmpty
            ? Center(child: Text('No items available'))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.runtimeType.toString()), // Adjust this based on your entity properties
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

  void listenToDeletePreferencesAction(BuildContext context) {
    ref.listen<AsyncValue>(deletePreferencesProvider, (previous, next) {
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
          ref.refresh(deletePreferencesProvider);
        });
      } else if (previous?.isLoading == true && next.hasValue) {
        Navigator.of(barrierContext!).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully deleted")),
        );
        // Refresh the list after successful deletion
        ref.refresh(getAllPreferencesProvider);
      }
    });
  }

  // TODO: Implement listeners for other actions
  // void listenToAddPreferencesAction(BuildContext context) {
  //   ref.listen<AsyncValue>(addPreferencesProvider, (previous, next) {
  //     // Implementation similar to listenToDeletePreferencesAction
  //   });
  // }

  // void listenToUpdatePreferencesAction(BuildContext context) {
  //   ref.listen<AsyncValue>(updatePreferencesProvider, (previous, next) {
  //     // Implementation similar to listenToDeletePreferencesAction
  //   });
  // }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    // Implementation remains the same
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, PreferencesEntity item) {
    // Implementation remains the same
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String itemId)async  {
  final result = await   showDialog(
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
    if(result==true){
    ref.read(deletePreferencesProvider.notifier).delete(itemId);
    }
  }
}
