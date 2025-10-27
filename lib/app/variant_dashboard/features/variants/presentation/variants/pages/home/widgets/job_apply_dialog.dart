import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/profile_provider.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/provider/home_screen_provider.dart';

class ApplyJobDialog extends ConsumerStatefulWidget {
  // final MobileJobEntity posting;
  final String postingTitle;
  final String postingId;
  const ApplyJobDialog(
      {super.key, required this.postingTitle, required this.postingId});

  @override
  _ApplyJobDialogState createState() => _ApplyJobDialogState();
}

class _ApplyJobDialogState extends ConsumerState<ApplyJobDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      applyJobProvider,
      (AsyncValue<void>? previous, AsyncValue<void> next) {
        if (previous?.isLoading == true && next.hasError) {
          print('eror ${next.error}');
          // if (!mounted) return;

          // CustomSnackbar.showFailureSnackbar(
          //   context,
          //   "Failed to apply job ${next.error}",
          // );
          // Close dialog and signal explicit failure to caller
          Navigator.of(context).pop(false);
        } else if (previous?.isLoading == true && next.hasValue) {
          if (!mounted) return;
          // Show snackbar first while the context is still mounted,
          // then close the dialog.
          // CustomSnackbar.showSuccessSnackbar(
          //   context,
          //   "Successfully applied to job",
          // );
          Navigator.of(context).pop(true);
        }
      },
    );

    final jobProvider = ref.watch(applyJobProvider);

    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    minWidth: 320,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.work_outline_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Apply to Position',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A202C),
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.postingTitle,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF4B5563),
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Content Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Note Input
                            const Text(
                              'Why are you interested? (Optional)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary2,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _noteController,
                                maxLines: 4,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF1A202C),
                                  height: 1.5,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Share your motivation, relevant experience, or why you\'d be a great fit...',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(18),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Action Buttons
                            Row(
                              children: [
                                // Cancel Button
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: TextButton(
                                      onPressed: jobProvider.isLoading
                                          ? null
                                          : () {
                                              _animationController
                                                  .reverse()
                                                  .then((_) {
                                                Navigator.pop(context);
                                              });
                                            },
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF1F5F9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Apply Button
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: jobProvider.isLoading
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: AppColors.primaryColor
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                    ),
                                    child: TextButton(
                                      onPressed: jobProvider.isLoading
                                          ? null
                                          : _submitApplication,
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: jobProvider.isLoading
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.white.withValues(
                                                          alpha: 0.8),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Applying...',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.send_rounded,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitApplication() async {
    // 1) Gate: ensure profile is complete before applying
    final isComplete =
        await ref.read(profileProvider.notifier).isProfileComplete();
    if (!isComplete) {
      // Inform and redirect to ProfilePage
      if (!mounted) return;
      Navigator.of(context).pop();

      await showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Action required',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please complete your profile before applying.',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      if (mounted) {
                        ref.read(appHomeNavIndexProvider.notifier).state = 3;
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Go to Profile'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
      return;
    }

    // 2) Proceed to apply if profile complete
    final candidateId = ref.read(jobDashboardDataProvider).candidate.id;
    final note = _noteController.text.trim().isEmpty
        ? 'Applied via mobile app'
        : _noteController.text.trim();
    final application = ApplyJobDTOEntity(
      candidateId: candidateId,
      jobPostingId: widget.postingId,
      note: note,
      name: 'candidate-mobile-app',
    );

    await ref.read(applyJobProvider.notifier).applyJob(application);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
