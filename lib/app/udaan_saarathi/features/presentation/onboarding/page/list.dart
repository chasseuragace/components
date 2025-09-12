// lib/features/onboarding/presentation/pages/list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/onboarding_screen_1.dart';
import '../../../domain/entities/onboarding/entity.dart';
import '../providers/providers.dart';

class OnboardingListPage extends ConsumerStatefulWidget {
  @override
  _OnboardingListPageState createState() => _OnboardingListPageState();
}

class _OnboardingListPageState extends ConsumerState<OnboardingListPage> {
  BuildContext? barrierContext;



  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(getAllOnboardingProvider);
      listenToDeleteOnboardingAction(context);
      // TODO: Set up listeners for other actions
      // listenToAddOnboardingAction(context);
      // listenToUpdateOnboardingAction(context);
    return Scaffold(
      
      body: onboardingState.when(
        data: (items) => items.isEmpty
            ? Center(child: Text('No items available'))
            : OnboardingScreen1(onboardingData: items,),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAddDialog(context, ref);
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void listenToDeleteOnboardingAction(BuildContext context) {
    ref.listen<AsyncValue>(deleteOnboardingProvider, (previous, next) {
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
          ref.refresh(deleteOnboardingProvider);
        });
      } else if (previous?.isLoading == true && next.hasValue) {
        Navigator.of(barrierContext!).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully deleted")),
        );
        // Refresh the list after successful deletion
        ref.refresh(getAllOnboardingProvider);
      }
    });
  }

  // TODO: Implement listeners for other actions
  // void listenToAddOnboardingAction(BuildContext context) {
  //   ref.listen<AsyncValue>(addOnboardingProvider, (previous, next) {
  //     // Implementation similar to listenToDeleteOnboardingAction
  //   });
  // }

  // void listenToUpdateOnboardingAction(BuildContext context) {
  //   ref.listen<AsyncValue>(updateOnboardingProvider, (previous, next) {
  //     // Implementation similar to listenToDeleteOnboardingAction
  //   });
  // }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    // Implementation remains the same
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, OnboardingEntity item) {
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
    ref.read(deleteOnboardingProvider.notifier).delete(itemId);
    }
  }
}
