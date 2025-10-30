import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';

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