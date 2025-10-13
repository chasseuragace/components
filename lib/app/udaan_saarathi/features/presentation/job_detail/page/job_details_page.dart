import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/favorites/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/job_detail/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/providers/providers.dart'
    show getJobsByIdProvider;
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/provider/home_screen_provider.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/widgets/job_apply_dialog.dart';

final selectedJobIdProvider = StateProvider<String?>((ref) => null);

class JobDetailPage extends ConsumerStatefulWidget {
  final MobileJobEntity job;

  const JobDetailPage({super.key, required this.job});

  @override
  ConsumerState<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends ConsumerState<JobDetailPage> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    final jobdataprovider = ref.watch(getJobsByIdProvider);
    final isApplied = ref.watch(jobAppliedProvider(job.id));

    return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Job Detail"),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Color(0xFFE67E22),
                  size: 20,
                ),
                onPressed: () async {
                  await ref
                      .read(addFavoritesProvider.notifier)
                      .addFavorites(job.id);
                  setState(() {
                    isSaved = !isSaved;
                  });
                },
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.bookmark_border),
            //   onPressed: () {
            //     setState(() {
            //       isSaved = !isSaved;
            //     });
            //   },
            // ),
          ],
        ),
        body: jobdataprovider.when(
          data: (MobileJobEntity? data) {
            // Prefer fetched data; fall back to the job passed into the page
            final effective = data ?? job;
            return body(effective, isApplied);
          },
          error: (Object error, StackTrace stackTrace) {
            // Show the page with fallback data to avoid blank screen
            return Center(child: Text("error : $error\n$stackTrace"));
          },
          loading: () {
            // Show the page with fallback data while loading
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  Column body(MobileJobEntity job, bool isApplied) {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JobTitleSection(job: job),
                    const SizedBox(height: 24),
                    CompanyDetailsSection(job: job),
                    const SizedBox(height: 24),
                    // Quick Info Cards
                    // QuickInfoSection(job: job),
                    // const SizedBox(height: 24),

                    // Job Overview
                    JobOverviewSection(job: job),
                    const SizedBox(height: 24),
                    OtherPositionsSection(job: job),
                    const SizedBox(height: 24),

                    // Contract & Employment Details
                    ContractDetailsSection(job: job),
                    const SizedBox(height: 24),
                    FacilitiesSection(job: job),
                    const SizedBox(height: 24),

                    // Salary Information
                    SalarySection(job: job),
                    const SizedBox(height: 24),
                    RequirementsSection(job: job),
                    // Requirements
                    // LegacyRequirementsSection(allRequirements: job.positions.expand((p) => p.requirements).toList()),
                    const SizedBox(height: 24),
                    const JobImageSection(),
                    const SizedBox(height: 24),
                    CompanyPolicySection(job: job),
                    const SizedBox(height: 24),

                    // Other Positions
                    // if (job['otherPositions'] != null &&
                    //     (job['otherPositions'] as List).isNotEmpty)
                    //   OtherPositionsSection(job: job),
                    AgencySection(job: job),
                    const SizedBox(height: 24),
                    // Action Buttons
                    //remove this if using bottom action buttonsgh
                    // const ActionButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // use this if required instead of action buttons
      BottomActionButtons(
        onApply: (widget.job.isActive && !isApplied)
            ? () => _applyToJob(context, widget.job)
            : null,
        onContact: () {
          // your contact logic
        },
        onWebView: () {
          // your webview logic
        },
      )
    ]);
  }

  void _applyToJob(BuildContext context, MobileJobEntity posting) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ApplyJobDialog(posting: posting),
    );
    if (result == true) {
      ref.read(jobAppliedProvider(posting.id).notifier).state = true;
      if (context.mounted) {
        CustomSnackbar.showSuccessSnackbar(
          context,
          "Successfully applied to job",
        );
      }
    } else {
      if (context.mounted) {
        CustomSnackbar.showFailureSnackbar(
          context,
          "Failed to apply job ",
        );
      }
    }
  }
}
// Quick Info Section with cards
//   Widget _buildQuickInfoSection(JobPosting job) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildInfoCard(
//             icon: Icons.location_on_outlined,
//             title: 'Location',
//             value: job.location ?? 'Not specified',
//             color: const Color(0xFF059669),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildInfoCard(
//             icon: Icons.schedule_outlined,
//             title: 'Posted',
//             value: job.postedDate.toString() ?? 'Recently',
//             color: const Color(0xFF0891B2),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildInfoCard(
//             icon: Icons.trending_up_outlined,
//             title: 'Match',
//             value: '${job.matchPercentage ?? 0}%',
//             color: _getMatchColor(
//               int.tryParse(job.matchPercentage ?? '0') ?? 0,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionContainer({
//     required String title,
//     required IconData icon,
//     required Color iconColor,
//     required List<Widget> children,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: AppColors.blackColor, blurRadius: 12),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: iconColor),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...children,
//         ],
//       ),
//     );
//   }

//   // Job Overview Section
//   Widget _buildJobOverviewSection(JobPosting job) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3B82F6).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.work_outline,
//                   color: Color(0xFF3B82F6),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Job Overview',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildOverviewRow('Position', job.postingTitle ?? 'Not specified'),
//           _buildOverviewRow(
//             'Experience Level',
//             job.experience ?? 'Not specified',
//           ),
//           _buildOverviewRow('Employment Type', job.type ?? 'Not specified'),
//           if (job.isRemote == true)
//             _buildOverviewRow(
//               'Work Mode',
//               'Remote Available',
//               isHighlight: true,
//             ),
//           if (job.isFeatured == true)
//             _buildOverviewRow('Status', 'Featured Position', isHighlight: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewRow(
//     String label,
//     String value, {
//     bool isHighlight = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF64748B),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: isHighlight
//                   ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
//                   : null,
//               decoration: isHighlight
//                   ? BoxDecoration(
//                       color: const Color(0xFF10B981).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(6),
//                     )
//                   : null,
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: isHighlight
//                       ? const Color(0xFF10B981)
//                       : const Color(0xFF1E293B),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Contract & Employment Details
//   Widget _buildContractDetailsSection(JobPosting job) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF8B5CF6).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.business_outlined,
//                   color: Color(0xFF8B5CF6),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Contract & Employment',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildDetailRow(
//             'Agency',
//             job.agency ?? 'Direct Hire',
//             Icons.apartment,
//           ),
//           _buildDetailRow('Employer', job.employer, Icons.domain),
//           _buildDetailRow(
//             'Contract Type',
//             job.type ?? 'Not specified',
//             Icons.description_outlined,
//           ),
//           //TODO
//           // _buildDetailRow(
//           //   'Department',
//           //   job.de ?? 'Not specified',
//           //   Icons.group_outlined,
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFacilitiesSection(JobPosting job) {
//     final facilities =
//         //  job.facilities?.isNotEmpty == true
//         //     ? job.facilities
//         //     :
//         [
//       'Free accommodation',
//       'Transportation provided',
//       'Health insurance',
//       'Annual leave',
//       'Training programs',
//       'Career development',
//     ];

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header row (same as Contract & Employment)
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF10B981).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.business_outlined,
//                   color: Color(0xFF10B981),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Company Facilities',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Facilities in "detail row" layout
//           Column(
//             children: facilities
//                 .map(
//                   (facility) => _buildDetailRow2(
//                     facility.toString(),
//                     "Yes", // or leave blank if you just want facility names
//                     Icons.check_circle,
//                   ),
//                 )
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   // Salary Section
//   Widget _buildSalarySection(JobPosting job) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF059669).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.attach_money,
//                   color: Color(0xFF059669),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Compensation',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   const Color(0xFF059669).withOpacity(0.1),
//                   const Color(0xFF10B981).withOpacity(0.05),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Base Salary',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF64748B),
//                       ),
//                     ),
//                     Text(
//                       job.salary ?? 'Negotiable',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF059669),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (job.convertedSalary != null) ...[
//                   const SizedBox(height: 12),
//                   const Divider(color: Color(0xFFE2E8F0)),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Converted Amount',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF64748B),
//                         ),
//                       ),
//                       Text(
//                         job.convertedSalary ?? 'Not specified',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF059669),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 // TODO
//                 // if (job['benefits'] != null) ...[
//                 //   const SizedBox(height: 12),
//                 //   const Divider(color: Color(0xFFE2E8F0)),
//                 //   const SizedBox(height: 12),
//                 //   const Align(
//                 //     alignment: Alignment.centerLeft,
//                 //     child: Text(
//                 //       'Benefits',
//                 //       style: TextStyle(
//                 //         fontSize: 14,
//                 //         fontWeight: FontWeight.w500,
//                 //         color: Color(0xFF64748B),
//                 //       ),
//                 //     ),
//                 //   ),
//                 //   const SizedBox(height: 8),
//                 //   Wrap(
//                 //     spacing: 8,
//                 //     runSpacing: 8,
//                 //     children: (job['benefits'] as List<dynamic>? ?? [])
//                 //         .map(
//                 //           (benefit) => Container(
//                 //             padding: const EdgeInsets.symmetric(
//                 //               horizontal: 8,
//                 //               vertical: 4,
//                 //             ),
//                 //             decoration: BoxDecoration(
//                 //               color: const Color(0xFF059669).withOpacity(0.1),
//                 //               borderRadius: BorderRadius.circular(6),
//                 //             ),
//                 //             child: Text(
//                 //               benefit.toString(),
//                 //               style: const TextStyle(
//                 //                 fontSize: 12,
//                 //                 fontWeight: FontWeight.w500,
//                 //                 color: Color(0xFF059669),
//                 //               ),
//                 //             ),
//                 //           ),
//                 //         )
//                 //         .toList(),
//                 //   ),
//                 // ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRequirementSection(JobPosting job) {
//     final requirements = job.positions as List<dynamic>? ??
//         [
//           'Bachelor\'s degree in relevant field',
//           'Minimum 2 years of experience',
//           'Strong communication skills',
//           'Proficiency in English',
//           'Valid passport',
//         ];
//     final allRequirements =
//         job.positions.expand((p) => p.requirements).toList();
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF59E0B).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.checklist_outlined,
//                   color: Color(0xFFF59E0B),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Requirements',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ...allRequirements.asMap().entries.map((entry) {
//             final index = entry.key;
//             final requirement = entry.value;
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(
//                       child: Text(
//                         '${index + 1}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 2),
//                       child: Text(
//                         requirement.toString(),
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF374151),
//                           height: 1.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   // Requirements Section
//   // Widget _buildRequirementsSection(JobPosting job) {
//   //   final allRequirements = job.positions
//   //       .expand((p) => p.requirements)
//   //       .toList();

//   //   return Container(
//   //     padding: const EdgeInsets.all(20),
//   //     decoration: BoxDecoration(
//   //       color: Colors.white,
//   //       borderRadius: BorderRadius.circular(20),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: AppColors.blackColor,
//   //           blurRadius: 12,
//   //           offset: const Offset(0, 4),
//   //         ),
//   //       ],
//   //     ),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Row(
//   //           children: [
//   //             Container(
//   //               padding: const EdgeInsets.all(8),
//   //               decoration: BoxDecoration(
//   //                 color: const Color(0xFFF59E0B).withOpacity(0.1),
//   //                 borderRadius: BorderRadius.circular(8),
//   //               ),
//   //               child: const Icon(
//   //                 Icons.checklist_outlined,
//   //                 color: Color(0xFFF59E0B),
//   //                 size: 20,
//   //               ),
//   //             ),
//   //             const SizedBox(width: 12),
//   //             const Text(
//   //               'Requirements',
//   //               style: TextStyle(
//   //                 fontSize: 18,
//   //                 fontWeight: FontWeight.bold,
//   //                 color: Color(0xFF1E293B),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         const SizedBox(height: 16),
//   //         ...allRequirements.map(
//   //           (req) => Container(
//   //             margin: const EdgeInsets.only(bottom: 12),
//   //             padding: const EdgeInsets.all(12),
//   //             decoration: BoxDecoration(
//   //               color: const Color(0xFFF8FAFC),
//   //               borderRadius: BorderRadius.circular(12),
//   //               border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
//   //             ),
//   //             child: Row(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Container(
//   //                   margin: const EdgeInsets.only(top: 2),
//   //                   width: 6,
//   //                   height: 6,
//   //                   decoration: const BoxDecoration(
//   //                     color: Color(0xFF3B82F6),
//   //                     shape: BoxShape.circle,
//   //                   ),
//   //                 ),
//   //                 const SizedBox(width: 12),
//   //                 Expanded(
//   //                   child: Text(
//   //                     req.toString(),
//   //                     style: const TextStyle(
//   //                       fontSize: 14,
//   //                       fontWeight: FontWeight.w500,
//   //                       color: Color(0xFF374151),
//   //                       height: 1.4,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Other Positions Section
//   Widget _buildOtherPositionsSection(JobPosting job) {
//     //TODO
//     final otherPositions = job.positions;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF6366F1).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.work_history_outlined,
//                   color: Color(0xFF6366F1),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Other Open Positions',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...otherPositions.map(
//             (position) => Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF6366F1).withOpacity(0.05),
//                     const Color(0xFF8B5CF6).withOpacity(0.02),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: const Color(0xFF6366F1).withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF6366F1).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_forward_ios,
//                       color: Color(0xFF6366F1),
//                       size: 12,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       position.toString(),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF374151),
//                       ),
//                     ),
//                   ),
//                   const Icon(
//                     Icons.open_in_new,
//                     color: Color(0xFF6366F1),
//                     size: 16,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: const Color(0xFF64748B)),
//           const SizedBox(width: 12),
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF64748B),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow2(String label, String value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: const Color(0xFF64748B)),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF64748B),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildJobImageSection(JobPosting job) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Job Advertisement',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A1A),
//               letterSpacing: -0.5,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             width: double.infinity,
//             height: 200,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFAFAFA),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: const Color(0xFFE5E7EB)),
//             ),
//             child: const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.image_outlined,
//                     size: 48,
//                     color: Color(0xFF9CA3AF),
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     'Job Advertisement Image',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF6B7280),
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Newspaper or online posting',
//                     style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Section 9: Company Policy - Clean Typography
//   Widget _buildCompanyPolicySection(JobPosting job) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Company Policy',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A1A),
//               letterSpacing: -0.5,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             job.policy ??
//                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF6B7280),
//               height: 1.7,
//               letterSpacing: 0.1,
//             ),
//             textAlign: TextAlign.justify,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAgencySection(JobPosting job) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Agency Information',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A1A),
//               letterSpacing: -0.5,
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildAgencyInfoRow('Agency Name', job.agency ?? 'Direct Hire'),
//           _buildAgencyInfoRow('Salary Range', job.salary ?? 'Negotiable'),
//           _buildAgencyInfoRow(
//             'Experience Required',
//             job.experience ?? '2-3 years',
//           ),
//           _buildAgencyInfoRow(
//             'Applications',
//             '${job.applications ?? 45} candidates',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAgencyInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF6B7280),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF1A1A1A),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Action Buttons
//   Widget _buildActionButtons() {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               // Apply logic here
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2563EB),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.send_outlined, size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   'Apply Now',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: () {
//                   // Share logic here
//                 },
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: const Color(0xFF2563EB),
//                   side: const BorderSide(color: Color(0xFF2563EB)),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.share_outlined, size: 18),
//                     SizedBox(width: 6),
//                     Text(
//                       'Share',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: () {
//                   // Save for later logic here
//                 },
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: const Color(0xFF059669),
//                   side: const BorderSide(color: Color(0xFF059669)),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.bookmark_border, size: 18),
//                     SizedBox(width: 6),
//                     Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Color _getMatchColor(int percentage) {
//     if (percentage >= 90) return const Color(0xFF059669);
//     if (percentage >= 75) return const Color(0xFF0891B2);
//     if (percentage >= 60) return const Color(0xFFF59E0B);
//     return const Color(0xFFEF4444);
//   }

//   // Section 1: Job Title with Posted Date - Elegant and Minimal
//   Widget _buildJobTitleSection(JobPosting job) {
//     return Container(
//       padding: const EdgeInsets.all(28),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             job.postingTitle,
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A1A),
//               height: 1.2,
//               letterSpacing: -0.8,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.schedule_outlined,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Posted ${job.postedDate.timeAgo}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF8F9FA),
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(color: const Color(0xFFE5E7EB)),
//                 ),
//                 child: Text(
//                   'Full Time',
//                   style: const TextStyle(
//                     color: Color(0xFF6B7280),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompanyDetailsSection(JobPosting job) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.blackColor,
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Company Details',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A1A),
//               letterSpacing: -0.5,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Container(
//                 width: 64,
//                 height: 64,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Center(
//                   child: Text(
//                     job.companyLogo ?? job.employer.substring(0, 1),
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       job.employer,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       job.city,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF6B7280),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         _buildCompanyMetric(
//                           'Founded',
//                           '2010',
//                         ),
//                         const SizedBox(width: 16),
//                         _buildCompanyMetric(
//                           'Size',
//                           '500+ employees',
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompanyMetric(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 11,
//             color: Color(0xFF9CA3AF),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 13,
//             color: Color(0xFF374151),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
