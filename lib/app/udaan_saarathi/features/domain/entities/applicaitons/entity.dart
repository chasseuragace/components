import 'package:variant_dashboard/app/udaan_saarathi/core/enum/application_status.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/homepage/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';

class ApplicaitonsEntity {
  final String id;
  final String candidateId;
  final String jobPostingId;
  // final String status;
  final String? updatedBy;
  final MobileJobEntity? posting;
  final ApplicationStatus status;
  final String? note;
  // final List<ApplicationHistory> history;
  final String? appliedAt;
  final InterviewDetail? interviewDetail;

  ApplicaitonsEntity({
    required this.id,
    required this.candidateId,
    required this.jobPostingId,
    required this.status,
    this.updatedBy,
    this.appliedAt,
    this.interviewDetail,
    this.posting,
    this.note,
  });
}

class ApplicationPaginationWrapper {
  List<ApplicaitonsEntity> items;
  int? total, page, limit;

  ApplicationPaginationWrapper(
      {required this.items, this.total, this.page, this.limit});
}

// id
// candidate_id
// job_posting_id
// status
// agency_name
// interview
// created_at
// updated_at




// interview is 
// 'id': instance.id,
//   'interview_date_ad': ?instance.interviewDateAd?.toIso8601String(),
//   'interview_date_bs': ?instance.interviewDateBs,
//   'interview_time': ?instance.interviewTime,
//   'location': ?instance.location,
//   'contact_person': ?instance.contactPerson,
//   'required_documents': ?instance.requiredDocuments,
//   'notes': ?instance.notes,
//   'expenses': ?instance.expenses?.map((e) => e.toJson()).toList(),


//   and expense is list of 
//    'expense_type': instance.expenseType,
//   'who_pays': instance.whoPays,
//   'is_free': instance.isFree,
//   'amount': ?instance.amount,
//   'currency': ?instance.currency,
//   'refundable': instance.refundable,
//   'notes': ?instance.notes,