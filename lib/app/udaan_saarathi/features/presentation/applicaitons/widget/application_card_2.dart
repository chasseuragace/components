import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/application_status.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/page/detail_by_id.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/homepage/page/home_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/utils.dart';

class ApplicationCard2 extends ConsumerWidget {
  final ApplicaitonsEntity application;
  final bool isApplicaionList;
  const ApplicationCard2(
      {super.key, required this.application, this.isApplicaionList = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootNav = Navigator.of(context, rootNavigator: true);

    ref.listen<AsyncValue<void>>(
      withdrawJobProvider,
      (AsyncValue<void>? previous, AsyncValue<void> next) {
        if (previous?.isLoading == true && next.hasError) {
          if (rootNav.canPop()) rootNav.pop();

          CustomSnackbar.showFailureSnackbar(
            context,
            "Failed to withdraw job ${next.error}",
          );
        } else if (previous?.isLoading == true && next.hasValue) {
          if (rootNav.canPop()) rootNav.pop();
          CustomSnackbar.showSuccessSnackbar(
            context,
            "Successfully withdraw job",
          );
        }
      },
    );
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08), // soft, subtle shadow
            blurRadius: 12, // spread of the shadow
            offset: const Offset(0, 4), // vertical shadow movement
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Applied ${DateTime.parse(application.appliedAt!).timeAgo}',
                style: TextStyle(fontSize: 12, color: AppColors.kgreyShade600),
              ),
              StatusBadge(status: application.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    getStatusColor(application.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                getStatusIcon(application.status),
                color: getStatusColor(application.status),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.posting?.postingTitle ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    application.posting?.employer ?? "",
                    style:
                        TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.kgreyShade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        application.posting?.country ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kgreyShade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 12),
          if (application.status == ApplicationStatus.interviewScheduled) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBlueColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Interview Scheduled',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '20 May 2024 • Online',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.kgreyShade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              if (isApplicaionList)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(selectedApplicationIdProvider.notifier).state =
                          '9ec18bc4-ebef-4464-8a62-bb9c0de4c3bf';
                      // Navigate to detail page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ApplicationDetailPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006BA3),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (isApplicaionList && canWithdraw(application.status)) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _withdrawApplication(context, application, ref),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Withdraw',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }

  void _withdrawApplication(
      BuildContext context, ApplicaitonsEntity application, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Withdraw Application',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to withdraw your application for ${application.posting?.postingTitle}?',
          style: TextStyle(fontSize: 14, color: AppColors.kgreyShade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.kgreyShade600)),
          ),
          TextButton(
            onPressed: () {
              // Navigator.pop(context);
              ref
                  .read(withdrawJobProvider.notifier)
                  .withdrawJob(application.id);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
            ),
            child: Text(
              'Withdraw',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    //  CustomDialog.showCustomDialog(
    //                 context,
    //                 onTap: () async {

    //                 },
    //                 negativeText: 'No',
    //                 positiveText: 'Yes',
    //                 title: 'Would you like to withdraw your application?',
    //               );
  }
}
