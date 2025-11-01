import 'package:variant_dashboard/app/udaan_saarathi/core/enum/application_status.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';




class ApplicaitonsModel extends ApplicaitonsEntity {
 

  ApplicaitonsModel({
    required String id,
    required String candidateId,
    required String jobPostingId,
    required ApplicationStatus status,
    required String agencyName,
     InterviewEntity? interview,
     JobPostingEntity? jobPosting,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          candidateId: candidateId,
          jobPostingId: jobPostingId,
          status: status,
          agencyName: agencyName,
          interview: interview,
          jobPosting: jobPosting,
          appliedAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ApplicaitonsModel.fromJson(Map<String, dynamic> json) {
    return ApplicaitonsModel(
      id: json['id'] ?? '',
      candidateId: json['candidate_id'] ?? '',
      jobPostingId: json['job_posting_id'] ?? '',
      status: ApplicationStatus.fromValue(json['status'] ?? ''),
      agencyName: json['agency_name'] ?? '',
      interview: json['interview'] != null
          ? InterviewModel.fromJson(json['interview'])
          : null,
      jobPosting: json['job_posting'] != null
          ? JobPostingModel.fromJson(json['job_posting'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime(1970),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime(1970),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidate_id': candidateId,
      'job_posting_id': jobPostingId,
      'status': status.name,
      'agency_name': agencyName,
      'interview': (interview as InterviewModel?)?.toJson(),
      'job_posting': (jobPosting as JobPostingModel?)?.toJson(),
      'created_at': appliedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class JobPostingModel extends JobPostingEntity {
  JobPostingModel({
    required String title,
    required EmployerModel employer,
    required String country,
    String? city,
  }) : super(
          title: title,
          employer: employer,
          country: country,
          city: city,
        );

  factory JobPostingModel.fromJson(Map<String, dynamic> json) {
    return JobPostingModel(
      title: json['title'] ?? '',
      employer: EmployerModel.fromJson(json['employer'] ?? {}),
      country: json['country'] ?? '',
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'employer': (employer as EmployerModel).toJson(),
      'country': country,
      if (city != null) 'city': city,
    };
  }
}

class EmployerModel extends EmployerEntity {
  EmployerModel({
    required String companyName,
    required String country,
    String? city,
  }) : super(
          companyName: companyName,
          country: country,
          city: city,
        );

  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      companyName: json['company_name'] ?? '',
      country: json['country'] ?? '',
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'country': country,
      if (city != null) 'city': city,
    };
  }
}

class InterviewModel extends InterviewEntity {
  InterviewModel({
    required String id,
    required String interviewDateAd,
    required String interviewDateBs,
    required String interviewTime,
    required String location,
    required String contactPerson,
    required List<String> requiredDocuments,
    required String notes,
    required List<dynamic> expenses,
  }) : super(
          id: id,
          interviewDateAd: interviewDateAd,
          interviewDateBs: interviewDateBs,
          interviewTime: interviewTime,
          location: location,
          contactPerson: contactPerson,
          requiredDocuments: requiredDocuments,
          notes: notes,
          expenses: expenses,
        );

  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    return InterviewModel(
      id: json['id'] ?? '',
      interviewDateAd: json['interview_date_ad'] ?? '',
      interviewDateBs: json['interview_date_bs'] ?? '',
      interviewTime: json['interview_time'] ?? '',
      location: json['location'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      requiredDocuments: (json['required_documents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      notes: json['notes'] ?? '',
      expenses: json['expenses'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interview_date_ad': interviewDateAd,
      'interview_date_bs': interviewDateBs,
      'interview_time': interviewTime,
      'location': location,
      'contact_person': contactPerson,
      'required_documents': requiredDocuments,
      'notes': notes,
      'expenses': expenses,
    };
  }
}


