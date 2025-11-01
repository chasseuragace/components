import '../../../domain/entities/interviews/entity.dart';

class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({super.dateAd, super.dateBs, super.time});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        dateAd: json['date_ad'] as String?,
        dateBs: json['date_bs'] as String?,
        time: json['time'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (dateAd != null) 'date_ad': dateAd,
        if (dateBs != null) 'date_bs': dateBs,
        if (time != null) 'time': time,
      };
}

class ApplicationRefModel extends ApplicationRefEntity {
  const ApplicationRefModel({required super.id, super.status});

  factory ApplicationRefModel.fromJson(Map<String, dynamic> json) =>
      ApplicationRefModel(
        id: json['id'] as String,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (status != null) 'status': status,
      };
}

class PostingRefModel extends PostingRefEntity {
  const PostingRefModel({
    required super.id,
    super.postingTitle,
    super.country,
    super.city,
  });

  factory PostingRefModel.fromJson(Map<String, dynamic> json) => PostingRefModel(
        id: json['id'] as String,
        postingTitle: json['posting_title'] as String?,
        country: json['country'] as String?,
        city: json['city'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (postingTitle != null) 'posting_title': postingTitle,
        if (country != null) 'country': country,
        if (city != null) 'city': city,
      };
}

class AgencyRefModel extends AgencyRefEntity {
  const AgencyRefModel({super.id, super.name, super.licenseNumber, super.phones, super.emails, super.website});

  factory AgencyRefModel.fromJson(Map<String, dynamic> json) => AgencyRefModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        licenseNumber: json['license_number'] as String?,
        phones: (json['phones'] as List?)?.map((e) => e.toString()).toList(),
        emails: (json['emails'] as List?)?.map((e) => e.toString()).toList(),
        website: json['website'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (licenseNumber != null) 'license_number': licenseNumber,
        if (phones != null) 'phones': phones,
        if (emails != null) 'emails': emails,
        if (website != null) 'website': website,
      };
}

class EmployerRefModel extends EmployerRefEntity {
  const EmployerRefModel({super.id, super.companyName, super.country, super.city});

  factory EmployerRefModel.fromJson(Map<String, dynamic> json) => EmployerRefModel(
        id: json['id'] as String?,
        companyName: json['company_name'] as String?,
        country: json['country'] as String?,
        city: json['city'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (companyName != null) 'company_name': companyName,
        if (country != null) 'country': country,
        if (city != null) 'city': city,
      };
}

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    super.expenseType,
    super.whoPays,
    super.isFree,
    super.amount,
    super.currency,
    super.refundable,
    super.notes,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        expenseType: json['expense_type'] as String?,
        whoPays: json['who_pays'] as String?,
        isFree: json['is_free'] as bool?,
        amount: json['amount'] as num?,
        currency: json['currency'] as String?,
        refundable: json['refundable'] as bool?,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (expenseType != null) 'expense_type': expenseType,
        if (whoPays != null) 'who_pays': whoPays,
        if (isFree != null) 'is_free': isFree,
        if (amount != null) 'amount': amount,
        if (currency != null) 'currency': currency,
        if (refundable != null) 'refundable': refundable,
        if (notes != null) 'notes': notes,
      };
}

class InterviewsModel extends InterviewsEntity {
  InterviewsModel({
    required super.id,
    super.schedule,
    super.location,
    super.contactPerson,
    super.requiredDocuments,
    super.notes,
    super.application,
    super.posting,
    super.agency,
    super.employer,
    super.expenses,
    required super.rawJson,
  });

  factory InterviewsModel.fromJson(Map<String, dynamic> json) => InterviewsModel(
        id: json['id'] as String,
        schedule: json['schedule'] == null
            ? null
            : ScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
        location: json['location'] as String?,
        contactPerson: json['contact_person'] as String?,
        requiredDocuments: (json['required_documents'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        notes: json['notes'] as String?,
        application: json['application'] == null
            ? null
            : ApplicationRefModel.fromJson(
                json['application'] as Map<String, dynamic>),
        posting: json['posting'] == null
            ? null
            : PostingRefModel.fromJson(json['posting'] as Map<String, dynamic>),
        agency: json['agency'] == null
            ? null
            : AgencyRefModel.fromJson(json['agency'] as Map<String, dynamic>),
        employer: json['employer'] == null
            ? null
            : EmployerRefModel.fromJson(
                json['employer'] as Map<String, dynamic>),
        expenses: (json['expenses'] as List<dynamic>?)
            ?.map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        rawJson: json,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (schedule != null && schedule is ScheduleModel)
          'schedule': (schedule as ScheduleModel).toJson(),
        if (location != null) 'location': location,
        if (contactPerson != null) 'contact_person': contactPerson,
        if (requiredDocuments != null) 'required_documents': requiredDocuments,
        if (notes != null) 'notes': notes,
        if (application != null && application is ApplicationRefModel)
          'application': (application as ApplicationRefModel).toJson(),
        if (posting != null && posting is PostingRefModel)
          'posting': (posting as PostingRefModel).toJson(),
        if (agency != null && agency is AgencyRefModel)
          'agency': (agency as AgencyRefModel).toJson(),
        if (employer != null && employer is EmployerRefModel)
          'employer': (employer as EmployerRefModel).toJson(),
        if (expenses != null)
          'expenses': expenses!
              .map((e) => (e as ExpenseModel).toJson())
              .toList(),
      };
}

class InterviewsPaginationModel extends InterviewsPaginationEntity {
  InterviewsPaginationModel({
    required super.page,
    required super.limit,
    required super.total,
    required List<InterviewsEntity> super.items,
    required super.rawJson,
  });

  factory InterviewsPaginationModel.fromJson(Map<String, dynamic> json) =>
      InterviewsPaginationModel(
        page: (json['page'] as num?)?.toInt() ?? 0,
        limit: (json['limit'] as num?)?.toInt() ?? 0,
        total: (json['total'] as num?)?.toInt() ?? 0,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => InterviewsModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        rawJson: json,
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'items': items
            .map((e) => (e as InterviewsModel).toJson())
            .toList(),
      };
}

