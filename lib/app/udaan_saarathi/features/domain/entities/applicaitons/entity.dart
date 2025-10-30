import 'package:variant_dashboard/app/udaan_saarathi/core/enum/application_status.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/homepage/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';

// entity.dart

class JobPostingEntity {
  final String title;
  final EmployerEntity employer;
  final String country;
  final String? city;

  JobPostingEntity({
    required this.title,
    required this.employer,
    required this.country,
    this.city,
  });
}

class EmployerEntity {
  final String companyName;
  final String country;
  final String? city;

  EmployerEntity({
    required this.companyName,
    required this.country,
    this.city,
  });
}

class ApplicaitonsEntity {
  final String id;
  final String candidateId;
  final String jobPostingId;
  final ApplicationStatus status;
  final String agencyName;
  final InterviewEntity? interview;
  final JobPostingEntity? jobPosting;
  final DateTime appliedAt;
  final DateTime updatedAt;

  ApplicaitonsEntity({
    required this.id,
    required this.candidateId,
    required this.jobPostingId,
    required this.status,
    required this.agencyName,
    required this.interview,
    this.jobPosting,
    required this.appliedAt,
    required this.updatedAt,
  });
}

class InterviewEntity {
  final String id;
  final String interviewDateAd;
  final String interviewDateBs;
  final String interviewTime;
  final String location;
  final String contactPerson;
  final List<String> requiredDocuments;
  final String notes;
  final List<dynamic> expenses;

  InterviewEntity({
    required this.id,
    required this.interviewDateAd,
    required this.interviewDateBs,
    required this.interviewTime,
    required this.location,
    required this.contactPerson,
    required this.requiredDocuments,
    required this.notes,
    required this.expenses,
  });
}
