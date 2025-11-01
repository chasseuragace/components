import '../../base_entity.dart';

class ScheduleEntity {
  final String? dateAd;
  final String? dateBs;
  final String? time;

  const ScheduleEntity({this.dateAd, this.dateBs, this.time});
}

class ApplicationRefEntity {
  final String id;
  final String? status;
  const ApplicationRefEntity({required this.id, this.status});
}

class PostingRefEntity {
  final String id;
  final String? postingTitle;
  final String? country;
  final String? city;
  const PostingRefEntity({
    required this.id,
    this.postingTitle,
    this.country,
    this.city,
  });
}

class AgencyRefEntity {
  final String? id;
  final String? name;
  final String? licenseNumber;
  final List<String>? phones;
  final List<String>? emails;
  final String? website;
  const AgencyRefEntity({
    this.id,
    this.name,
    this.licenseNumber,
    this.phones,
    this.emails,
    this.website,
  });
}

class EmployerRefEntity {
  final String? id;
  final String? companyName;
  final String? country;
  final String? city;
  const EmployerRefEntity({this.id, this.companyName, this.country, this.city});
}

class ExpenseEntity {
  final String? expenseType;
  final String? whoPays;
  final bool? isFree;
  final num? amount;
  final String? currency;
  final bool? refundable;
  final String? notes;
  const ExpenseEntity({
    this.expenseType,
    this.whoPays,
    this.isFree,
    this.amount,
    this.currency,
    this.refundable,
    this.notes,
  });
}

abstract class InterviewsEntity extends BaseEntity {
  final String id;
  final ScheduleEntity? schedule;
  final String? location;
  final String? contactPerson;
  final List<String>? requiredDocuments;
  final String? notes;
  final ApplicationRefEntity? application;
  final PostingRefEntity? posting;
  final AgencyRefEntity? agency;
  final EmployerRefEntity? employer;
  final List<ExpenseEntity>? expenses;

  InterviewsEntity({
    required super.rawJson,
    required this.id,
    this.schedule,
    this.location,
    this.contactPerson,
    this.requiredDocuments,
    this.notes,
    this.application,
    this.posting,
    this.agency,
    this.employer,
    this.expenses,
  });
}

class InterviewsPaginationEntity extends BaseEntity {
  final int page;
  final int limit;
  final int total;
  final List<InterviewsEntity> items;

  InterviewsPaginationEntity({
    required super.rawJson,
    required this.page,
    required this.limit,
    required this.total,
    required this.items,
  });
}

// {
//   "page": 0,
//   "limit": 0,
//   "total": 0,
//   "items": [
//     {
//       "id": "string",
//       "schedule": {
//         "date_ad": {},
//         "date_bs": {},
//         "time": {}
//       },
//       "location": {},
//       "contact_person": {},
//       "required_documents": [
//         "string"
//       ],
//       "notes": {},
//       "application": {
//         "id": "string",
//         "status": "string"
//       },
//       "posting": {
//         "id": "string",
//         "posting_title": "string",
//         "country": "string",
//         "city": {}
//       },
//       "agency": {
//         "name": "string",
//         "license_number": "string"
//       },
//       "employer": {
//         "company_name": "string",
//         "country": "string",
//         "city": {}
//       },
//       "expenses": [
//         {
//           "expense_type": "string",
//           "who_pays": "string",
//           "is_free": true,
//           "amount": 0,
//           "currency": "string",
//           "refundable": true,
//           "notes": "string"
//         }
//       ]
//     }
//   ]
// }