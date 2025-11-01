
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/application_status.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';

import '../../base_entity.dart';

abstract class HomepageEntity extends BaseEntity {
  final String id;
  HomepageEntity({
        // TODO : Homepage : Define params
        required super.rawJson,
        required this.id,
        });
}

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