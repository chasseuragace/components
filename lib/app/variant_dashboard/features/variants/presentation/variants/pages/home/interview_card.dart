import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/Interviews/model.dart'
    as interviews_model;

class InterviewCard extends StatelessWidget {
  final Application application;

  const InterviewCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return DummyInterviewCardPreview();
    final interview = application.interviewDetail!;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F7DF9), Color(0xFF6C5CE7)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  application.posting.postingTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat(
                  'MMM dd, yyyy • hh:mm a',
                ).format(interview.scheduledAt),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  interview.location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
          if (interview.notes != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                interview.notes!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final scheduledAt = _parseScheduledAt(interview);
    final title = interview.posting?.postingTitle ?? 'Interview ${interview.id}';
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
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F7DF9), Color(0xFF6C5CE7)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showFullData && status != null && status.trim().isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Text(
                    status.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 12),
          if (showFullData && (company != null || city != null || country != null)) ...[
            Row(
              children: [
                Icon(
                  Icons.apartment_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    [
                      if (company != null && company.trim().isNotEmpty) company,
                      if (city != null && city.trim().isNotEmpty) city,
                      if (country != null && country.trim().isNotEmpty) country,
                    ].join(' • '),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(scheduledAt),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
          if (showFullData && contact != null && contact.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.person_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    contact,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (showFullData && docs.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: -6,
              children: [
                ...docs.take(3).map((d) => Chip(
                      label: Text(d, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.black.withOpacity(0.15),
                      labelStyle: const TextStyle(color: Colors.white),
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                if (docs.length > 3)
                  Chip(
                    label: Text('+${docs.length - 3} more', style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.white.withOpacity(0.15),
                    labelStyle: const TextStyle(color: Colors.white),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          ],
          if (showFullData && notes != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                notes,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
          if (showFullData && expenses.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(width: 8),
                Text(
                  '${expenses.length} expense${expenses.length == 1 ? '' : 's'}',
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                )
              ],
            ),
            const SizedBox(height: 6),
            ...expenses.map((e) {
              final type = e.expenseType ?? 'Expense';
              final payer = e.whoPays ?? '-';
              final isFree = e.isFree == true;
              final refundable = e.refundable == true;
              final amountStr = isFree
                  ? 'Free'
                  : ((e.amount != null && e.currency != null)
                      ? '${e.amount} ${e.currency}'
                      : (e.amount != null ? e.amount.toString() : '-'));
              return Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$type • $payer • $amountStr',
                        style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (refundable)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          'REFUNDABLE',
                          style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
              );
            }),
            if (expenses.length > 3)
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 2),
                child: Text(
                  '+${expenses.length - 3} more',
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
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
      'notes': 'Bring original documents and arrive 10 mins early.',
      'application': {
        'id': 'app_789',
        'status': 'interview_scheduled'
      },
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
          'refundable': false,
          'notes': 'Covered by employer'
        }
      ]
    });

    return InterviewCardFromModel(interview: dummy, showFullData: true);
  }
}
