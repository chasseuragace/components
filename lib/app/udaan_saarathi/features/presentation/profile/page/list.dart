// lib/features/Profile/presentation/pages/list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/profile/entity.dart';
import '../providers/providers.dart';

class ProfileListPage extends ConsumerStatefulWidget {
  @override
  _ProfileListPageState createState() => _ProfileListPageState();
}

class _ProfileListPageState extends ConsumerState<ProfileListPage> {
  BuildContext? barrierContext;



  @override
  Widget build(BuildContext context) {
    final ProfileState = ref.watch(getAllProfileProvider);
      listenToDeleteProfileAction(context);
      // TODO: Set up listeners for other actions
      // listenToAddProfileAction(context);
      // listenToUpdateProfileAction(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile List'),
      ),
      body: ProfileState.when(
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

  void listenToDeleteProfileAction(BuildContext context) {
    ref.listen<AsyncValue>(deleteProfileProvider, (previous, next) {
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
          ref.refresh(deleteProfileProvider);
        });
      } else if (previous?.isLoading == true && next.hasValue) {
        Navigator.of(barrierContext!).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully deleted")),
        );
        // Refresh the list after successful deletion
        ref.refresh(getAllProfileProvider);
      }
    });
  }

  // TODO: Implement listeners for other actions
  // void listenToAddProfileAction(BuildContext context) {
  //   ref.listen<AsyncValue>(addProfileProvider, (previous, next) {
  //     // Implementation similar to listenToDeleteProfileAction
  //   });
  // }

  // void listenToUpdateProfileAction(BuildContext context) {
  //   ref.listen<AsyncValue>(updateProfileProvider, (previous, next) {
  //     // Implementation similar to listenToDeleteProfileAction
  //   });
  // }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    // Implementation remains the same
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, ProfileEntity item) {
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
    ref.read(deleteProfileProvider.notifier).delete(itemId);
    }
  }
}
