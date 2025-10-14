import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/Interviews/model.dart'
    as interviews_model;
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';

class InterviewCard extends StatelessWidget {
  final ApplicaitonsEntity application;

  const InterviewCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return DummyInterviewCardPreview();
    // final interview = application.interviewDetail!;

    // return Container(
    //   margin: const EdgeInsets.only(bottom: 16),
    //   padding: const EdgeInsets.all(20),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(12),
    //     border: Border.all(color: Colors.grey.shade200),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.04),
    //         blurRadius: 8,
    //         offset: const Offset(0, 2),
    //       ),
    //     ],
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // Title Section
    //       Row(
    //         children: [
    //           Container(
    //             padding: const EdgeInsets.all(8),
    //             decoration: BoxDecoration(
    //               color: const Color(0xFF4F7DF9).withOpacity(0.1),
    //               borderRadius: BorderRadius.circular(8),
    //             ),
    //             child: Icon(
    //               Icons.event_rounded,
    //               color: const Color(0xFF4F7DF9),
    //               size: 20,
    //             ),
    //           ),
    //           const SizedBox(width: 12),
    //           Expanded(
    //             child: Text(
    //               application.posting.postingTitle,
    //               style: const TextStyle(
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.w600,
    //                 color: Color(0xFF1A1A1A),
    //               ),
    //               maxLines: 2,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //         ],
    //       ),

    //       const SizedBox(height: 16),
    //       Divider(color: Colors.grey.shade200, height: 1),
    //       const SizedBox(height: 16),

    //       // Schedule Section
    //       Row(
    //         children: [
    //           Icon(
    //             Icons.schedule_rounded,
    //             color: Colors.grey.shade600,
    //             size: 18,
    //           ),
    //           const SizedBox(width: 12),
    //           Text(
    //             DateFormat('MMM dd, yyyy • hh:mm a')
    //                 .format(interview.scheduledAt),
    //             style: TextStyle(
    //               fontSize: 14,
    //               color: Colors.grey.shade700,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ],
    //       ),

    //       const SizedBox(height: 12),

    //       // Location Section
    //       Row(
    //         children: [
    //           Icon(
    //             Icons.location_on_rounded,
    //             color: Colors.grey.shade600,
    //             size: 18,
    //           ),
    //           const SizedBox(width: 12),
    //           Expanded(
    //             child: Text(
    //               interview.location,
    //               style: TextStyle(
    //                 fontSize: 14,
    //                 color: Colors.grey.shade700,
    //                 fontWeight: FontWeight.w500,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),

    //       // Notes Section
    //       if (interview.notes != null) ...[
    //         const SizedBox(height: 16),
    //         Divider(color: Colors.grey.shade200, height: 1),
    //         const SizedBox(height: 16),
    //         Container(
    //           width: double.infinity,
    //           padding: const EdgeInsets.all(16),
    //           decoration: BoxDecoration(
    //             color: Colors.grey.shade50,
    //             borderRadius: BorderRadius.circular(8),
    //             border: Border.all(color: Colors.grey.shade200),
    //           ),
    //           child: Text(
    //             interview.notes!,
    //             style: TextStyle(
    //               fontSize: 13,
    //               color: Colors.grey.shade700,
    //               height: 1.4,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ],
    //   ),
    // );
  }
}

/// A version of the Interview card that renders from InterviewsModel directly
class InterviewCardFromModel extends StatelessWidget {
  final interviews_model.InterviewsModel interview;
  final bool showFullData;

  const InterviewCardFromModel({
    super.key,
    required this.interview,
    this.showFullData = false,
  });

  DateTime? _parseScheduledAt(interviews_model.InterviewsModel m) {
    final sched = m.schedule as interviews_model.ScheduleModel?;
    if (sched == null) return null;
    final String? dateStr = sched.dateAd ?? sched.dateBs;
    final String? timeStr = sched.time;
    try {
      if (dateStr != null && timeStr != null) {
        return DateTime.tryParse('$dateStr $timeStr');
      } else if (dateStr != null) {
        return DateTime.tryParse(dateStr);
      }
    } catch (_) {}
    return null;
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Schedule TBD';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
  }

  String _locationText(interviews_model.InterviewsModel m) {
    final loc = m.location;
    if (loc != null && loc.trim().isNotEmpty) return loc;
    return 'Location TBD';
  }

  String? _notesText(interviews_model.InterviewsModel m) {
    final n = m.notes;
    if (n != null && n.trim().isNotEmpty) return n;
    return null;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'interview_scheduled':
        return AppColors.primaryColor;
      case 'interview_completed':
        return AppColors.secondaryColor;
      case 'interview_cancelled':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduledAt = _parseScheduledAt(interview);
    final title =
        interview.posting?.postingTitle ?? 'Interview ${interview.id}';
    final location = _locationText(interview);
    final notes = _notesText(interview);
    final status = interview.application?.status;
    final company = interview.employer?.companyName;
    final city = interview.employer?.city ?? interview.posting?.city;
    final country = interview.posting?.country ?? interview.employer?.country;
    final contact = interview.contactPerson;
    final docs = interview.requiredDocuments ?? const <String>[];
    final expenses = interview.expenses ?? const [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F7DF9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.event_rounded,
                  color: const Color(0xFF4F7DF9),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showFullData &&
                  status != null &&
                  status.trim().isNotEmpty) ...[
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    status.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(status),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ]
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),

          // Company Info Section
          if (showFullData &&
              (company != null || city != null || country != null)) ...[
            Row(
              children: [
                Icon(
                  Icons.apartment_rounded,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    [
                      if (company != null && company.trim().isNotEmpty) company,
                      if (city != null && city.trim().isNotEmpty) city,
                      if (country != null && country.trim().isNotEmpty) country,
                    ].join(' • '),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Schedule Section
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.grey.shade600,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                _formatDate(scheduledAt),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Location Section
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Colors.grey.shade600,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // Contact Person Section
          if (showFullData && contact != null && contact.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.person_rounded,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    contact,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Documents Section
          if (showFullData && docs.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.description_rounded,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  'Required Documents',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...docs.take(3).map((d) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                if (docs.length > 3)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      '+${docs.length - 3} more',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],

          // Expenses Section
          if (showFullData && expenses.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  'Expenses (${expenses.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...expenses.take(3).map((e) {
              final type = e.expenseType ?? 'Expense';
              final payer = e.whoPays ?? '-';
              final isFree = e.isFree == true;
              final refundable = e.refundable == true;
              final amountStr = isFree
                  ? 'Free'
                  : ((e.amount != null && e.currency != null)
                      ? '${e.amount} ${e.currency}'
                      : (e.amount != null ? e.amount.toString() : '-'));

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$payer • $amountStr',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (refundable)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF059669).withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'REFUNDABLE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            if (expenses.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${expenses.length - 3} more expenses',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],

          // Notes Section
          if (notes != null) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.note_rounded,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Notes',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notes,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A quick demo widget that constructs a dummy InterviewsModel and shows the card
class DummyInterviewCardPreview extends StatelessWidget {
  const DummyInterviewCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final dummy = interviews_model.InterviewsModel.fromJson({
      'id': 'iv_001',
      'schedule': {
        'date_ad': '2025-09-25',
        'date_bs': '2082-06-09',
        'time': '10:30:00',
      },
      'location': 'Kathmandu, Nepal',
      'contact_person': 'Ms. Priya Sharma',
      'required_documents': [
        'Passport (original)',
        'CV',
        'Academic Certificates'
      ],
      'notes':
          'Bring original documents and arrive 10 minutes early. The interview will be conducted in English.',
      'application': {'id': 'app_789', 'status': 'interview_scheduled'},
      'posting': {
        'id': 'p_100',
        'posting_title': 'Software Engineer',
        'country': 'Nepal',
        'city': 'Kathmandu'
      },
      'agency': {
        'id': 'ag_55',
        'name': 'Udaan Saarathi Agency',
        'license_number': 'LIC-2025-NEP-001',
        'phones': ['+977-1-5551234', '+977-9801234567'],
        'emails': ['contact@udaan-saarathi.com'],
        'website': 'https://udaan-saarathi.com'
      },
      'employer': {
        'id': 'emp_22',
        'company_name': 'TechWorks Pvt. Ltd.',
        'country': 'UAE',
        'city': 'Dubai'
      },
      'expenses': [
        {
          'expense_type': 'Medical Test',
          'who_pays': 'Candidate',
          'is_free': false,
          'amount': 50,
          'currency': 'USD',
          'refundable': false,
          'notes': 'Pay at clinic'
        },
        {
          'expense_type': 'Visa Fee',
          'who_pays': 'Employer',
          'is_free': true,
          'amount': 0,
          'currency': 'USD',
          'refundable': true,
          'notes': 'Covered by employer'
        }
      ]
    });

    return InterviewCardFromModel(interview: dummy, showFullData: true);
  }
}
