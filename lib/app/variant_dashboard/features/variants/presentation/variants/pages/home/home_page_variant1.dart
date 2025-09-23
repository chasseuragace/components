import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Changed from package:provider/provider.dart
import 'package:intl/intl.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/dashboard_header.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/interview_card.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/preferences_section.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/provider/home_screen_provider.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/recommended_jobs_section.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/widgets/job_apply_dialog.dart';

// Global Riverpod provider for JobDashboardData

// ENHANCED DATA MODELS (matching backend)
class Candidate {
  final String id;
  final String fullName;
  final String phone;
  final Map<String, dynamic>? address;
  final String? passportNumber;
  final List<String> skills;
  final List<Map<String, dynamic>> education;
  final bool isActive;

  Candidate({
    required this.id,
    required this.fullName,
    required this.phone,
    this.address,
    this.passportNumber,
    this.skills = const [],
    this.education = const [],
    this.isActive = true,
  });
}

class CandidatePreference {
  final String title;
  final int? priority;

  CandidatePreference({required this.title, this.priority});
}

class JobProfile {
  final String id;
  final String candidateId;
  final Map<String, dynamic> profileBlob;
  final String? label;
  final DateTime updatedAt;

  JobProfile({
    required this.id,
    required this.candidateId,
    required this.profileBlob,
    this.label,
    required this.updatedAt,
  });
}

class JobPosition {
  final String id;
  final String title;
  final String? baseSalary;
  final String? convertedSalary;
  final String? currency;
  final List<String> requirements;

  JobPosition({
    required this.id,
    required this.title,
    this.baseSalary,
    this.convertedSalary,
    this.currency,
    this.requirements = const [],
  });
}

class Application {
  final String id;
  final String candidateId;
  final String postingId;
  final MobileJobEntity posting;
  final ApplicationStatus status;
  final String? note;
  final List<ApplicationHistory> history;
  final DateTime appliedAt;
  final InterviewDetail? interviewDetail;

  Application({
    required this.id,
    required this.candidateId,
    required this.postingId,
    required this.posting,
    required this.status,
    this.note,
    this.history = const [],
    required this.appliedAt,
    this.interviewDetail,
  });
}

class InterviewDetail {
  final String id;
  final DateTime scheduledAt;
  final String location;
  final String contact;
  final String? notes;
  final bool isRescheduled;

  InterviewDetail({
    required this.id,
    required this.scheduledAt,
    required this.location,
    required this.contact,
    this.notes,
    this.isRescheduled = false,
  });
}

class ApplicationHistory {
  final String id;
  final ApplicationStatus status;
  final DateTime timestamp;
  final String? note;
  final String? updatedBy;

  ApplicationHistory({
    required this.id,
    required this.status,
    required this.timestamp,
    this.note,
    this.updatedBy,
  });
}

enum ApplicationStatus {
  applied,
  underReview,
  interviewScheduled,
  interviewRescheduled,
  interviewPassed,
  interviewFailed,
  withdrawn,
  rejected,
  accepted,
}

class JobFilters {
  final List<String>? countries;
  final SalaryFilter? salary;
  final String combineWith; // 'AND' or 'OR'

  JobFilters({this.countries, this.salary, this.combineWith = 'OR'});
}

class SalaryFilter {
  final double? min;
  final double? max;
  final String currency;
  final String source; // 'base' or 'converted'

  SalaryFilter({
    this.min,
    this.max,
    required this.currency,
    this.source = 'base',
  });
}

class DashboardAnalytics {
  final int recommendedJobsCount;
  final List<String> topMatchedTitles;
  final Map<String, int> countriesDistribution;
  final int recentlyAppliedCount;
  final int totalApplications;
  final int interviewsScheduled;

  DashboardAnalytics({
    required this.recommendedJobsCount,
    required this.topMatchedTitles,
    required this.countriesDistribution,
    required this.recentlyAppliedCount,
    required this.totalApplications,
    required this.interviewsScheduled,
  });
}

// class JobPostingCard extends StatelessWidget {
//   final JobPosting posting;

//   const JobPostingCard({super.key, required this.posting});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [AppColors.primaryColor, Color(0xFF6C5CE7)],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.business_center_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16.0),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         posting.postingTitle,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D3748),
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4.0),
//                       Text(
//                         '${posting.employer} via ${posting.agency}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF718096),
//                           fontWeight: FontWeight.w500,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             Row(
//               children: <Widget>[
//                 _buildInfoChip(
//                   Icons.location_on_rounded,
//                   '${posting.city}, ${posting.country}',
//                 ),
//                 const SizedBox(width: 12.0),
//                 _buildInfoChip(
//                   Icons.work_history_rounded,
//                   posting.contractTerms['type'] ?? 'Contract',
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),

//             // Positions
//             Text(
//               'Available Positions (${posting.positions.length})',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//             const SizedBox(height: 12.0),

//             ...posting.positions
//                 .take(2)
//                 .map<Widget>((position) => _buildPositionRow(position)),

//             if (posting.positions.length > 2)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   '+ ${posting.positions.length - 2} more positions',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: AppColors.primaryColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 16.0),
//             Row(
//               children: [
//                 Icon(
//                   Icons.schedule_rounded,
//                   size: 16,
//                   color: Color(0xFF718096),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   'Posted ${_formatDate(posting.postedDate)}',
//                   style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
//                 ),
//                 Spacer(),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: posting.isActive
//                         ? Colors.green.withOpacity(0.1)
//                         : Colors.grey.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     posting.isActive ? 'Active' : 'Closed',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: posting.isActive ? Colors.green : Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 48,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: AppColors.primaryColor.withOpacity(0.3),
//                       ),
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     child: TextButton(
//                       onPressed: () => _showJobDetails(context, posting),
//                       child: Text(
//                         'View Details',
//                         style: TextStyle(
//                           color: AppColors.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12.0),
//                 Expanded(
//                   child: Container(
//                     height: 48,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [AppColors.primaryColor, Color(0xFF6C5CE7)],
//                       ),
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     child: TextButton(
//                       onPressed: posting.isActive
//                           ? () => _applyToJob(context, posting)
//                           : null,
//                       child: Text(
//                         'Apply Now',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoChip(IconData icon, String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Color(0xFFF7FAFC),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: Color(0xFF718096)),
//           const SizedBox(width: 6.0),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 12,
//               color: Color(0xFF718096),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPositionRow(JobPosition position) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFE2E8F0)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   position.title,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 if (position.convertedSalary != null) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     '${position.convertedSalary} (${position.baseSalary})',
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: AppColors.primaryColor,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           Icon(
//             Icons.arrow_forward_ios_rounded,
//             size: 16,
//             color: Color(0xFF9CA3AF),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date).inDays;

//     if (difference == 0) return 'today';
//     if (difference == 1) return '1 day ago';
//     if (difference < 7) return '$difference days ago';
//     if (difference < 30) return '${(difference / 7).floor()} weeks ago';
//     return DateFormat.yMMMd().format(date);
//   }

//   void _showJobDetails(BuildContext context, JobPosting posting) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => JobDetailsModal(posting: posting),
//     );
//   }

//   void _applyToJob(BuildContext context, JobPosting posting) {
//     showDialog(
//       context: context,
//       builder: (context) => ApplyJobDialog(posting: posting),
//     );
//   }
// }

class JobDetailsModal extends StatelessWidget {
  final MobileJobEntity posting;

  const JobDetailsModal({super.key, required this.posting});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  posting.postingTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${posting.employer} via ${posting.agency}',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Location & Contract', [
                    _buildDetailRow(
                      'Location',
                      '${posting.city}, ${posting.country}',
                    ),
                    _buildDetailRow(
                      'Contract Type',
                      posting.contractTerms.type ?? 'Not specified',
                    ),
                    _buildDetailRow(
                      'Duration',
                      posting.contractTerms.duration ?? 'Not specified',
                    ),
                    _buildDetailRow('Posted', _formatDate(posting.postedDate)),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('Description', [
                    Text(
                      posting.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4B5563),
                        height: 1.6,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Available Positions (${posting.positions.length})',
                    posting.positions
                        .map<Widget>((pos) => _buildPositionCard(pos))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, Color(0xFF6C5CE7)],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: TextButton(
              onPressed: posting.isActive
                  ? () {
                      Navigator.pop(context);
                      _applyToJob(context, posting);
                    }
                  : null,
              child: Text(
                posting.isActive ? 'Apply Now' : 'Position Closed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionCard(JobPosition position) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  position.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              if (position.convertedSalary != null)
                Text(
                  position.convertedSalary!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
            ],
          ),
          if (position.baseSalary != null) ...[
            const SizedBox(height: 4),
            Text(
              'Base: ${position.baseSalary}',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
          if (position.requirements.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Requirements:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: position.requirements
                  .map<Widget>(
                    (req) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        req,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'today';
    if (difference == 1) return '1 day ago';
    if (difference < 7) return '$difference days ago';
    if (difference < 30) return '${(difference / 7).floor()} weeks ago';
    return DateFormat.yMMMd().format(date);
  }

  void _applyToJob(BuildContext context, MobileJobEntity posting) {
    showDialog(
      context: context,
      builder: (context) => ApplyJobDialog(posting: posting),
    );
  }
}

class ApplicationsSection extends ConsumerWidget {
  // Changed to ConsumerWidget
  const ApplicationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref
    final dashboardData = ref.watch(
      jobDashboardDataProvider,
    ); // Access data via ref
    final upcomingInterviews = dashboardData.getUpcomingInterviews();
    final recentApplications = dashboardData.applications.take(3).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0).copyWith(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (upcomingInterviews.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Interviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...upcomingInterviews.map<Widget>(
              (app) => InterviewCard(application: app),
            ),
            const SizedBox(height: 32),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Applications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recentApplications.isEmpty)
            _buildEmptyApplications(context)
          else
            ...recentApplications.map<Widget>(
              (app) => ApplicationCard(application: app),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyApplications(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(Icons.work_off_outlined, size: 48, color: Color(0xFF9CA3AF)),
          const SizedBox(height: 16),
          Text(
            'No applications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start applying to jobs that match your preferences',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final Application application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor(application.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(application.status),
                  color: _getStatusColor(application.status),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.posting.postingTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      application.posting.employer,
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(application.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Applied ${_formatDate(application.appliedAt)}',
                style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
              Spacer(),
              if (_canWithdraw(application.status))
                TextButton(
                  onPressed: () => _withdrawApplication(context, application),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    'Withdraw',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ApplicationStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          fontSize: 12,
          color: _getStatusColor(status),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return AppColors.primaryColor;
      case ApplicationStatus.underReview:
        return Color(0xFFF59E0B);
      case ApplicationStatus.interviewScheduled:
      case ApplicationStatus.interviewRescheduled:
        return Color(0xFF10B981);
      case ApplicationStatus.interviewPassed:
      case ApplicationStatus.accepted:
        return Color(0xFF059669);
      case ApplicationStatus.interviewFailed:
      case ApplicationStatus.rejected:
      case ApplicationStatus.withdrawn:
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  IconData _getStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return Icons.send_rounded;
      case ApplicationStatus.underReview:
        return Icons.visibility_rounded;
      case ApplicationStatus.interviewScheduled:
      case ApplicationStatus.interviewRescheduled:
        return Icons.event_rounded;
      case ApplicationStatus.interviewPassed:
      case ApplicationStatus.accepted:
        return Icons.check_circle_rounded;
      case ApplicationStatus.interviewFailed:
      case ApplicationStatus.rejected:
      case ApplicationStatus.withdrawn:
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.interviewScheduled:
        return 'Interview Scheduled';
      case ApplicationStatus.interviewRescheduled:
        return 'Interview Rescheduled';
      case ApplicationStatus.interviewPassed:
        return 'Interview Passed';
      case ApplicationStatus.interviewFailed:
        return 'Interview Failed';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.accepted:
        return 'Accepted';
    }
  }

  bool _canWithdraw(ApplicationStatus status) {
    return status == ApplicationStatus.applied ||
        status == ApplicationStatus.underReview ||
        status == ApplicationStatus.interviewScheduled ||
        status == ApplicationStatus.interviewRescheduled;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'today';
    if (difference == 1) return '1 day ago';
    if (difference < 7) return '$difference days ago';
    if (difference < 30) return '${(difference / 7).floor()} weeks ago';
    return DateFormat.yMMMd().format(date);
  }

  void _withdrawApplication(BuildContext context, Application application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Withdraw Application',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        content: Text(
          'Are you sure you want to withdraw your application for ${application.posting.postingTitle}?',
          style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Application withdrawn successfully'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
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
  }
}

// MAIN APP
class HomePageVariant1 extends StatelessWidget {
  const HomePageVariant1({super.key});

  @override
  Widget build(BuildContext context) {
    // No ChangeNotifierProvider here, as it's defined globally for Riverpod
    return MaterialApp(
      title: 'Job Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color(0xFF2D3748)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: JobDashboardScreen(),
    );
  }
}

class JobDashboardScreen extends ConsumerWidget {
  const JobDashboardScreen({super.key});
  // Changed to ConsumerWidget
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DashboardHeader(),
            PreferencesSection(),
            RecommendedJobsSection(),
            ApplicationsSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
