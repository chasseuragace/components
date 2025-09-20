
import '../../base_entity.dart';
import 'address.dart';

abstract class CandidateEntity extends BaseEntity {
  final String id;
  final String? fullName;
  final String? phone;
  final AddressEntity? address;
  final String? passportNumber;
  final String? gender;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CandidateEntity({
    required super.rawJson,
    required this.id,
    this.fullName,
    this.phone,
    this.address,
    this.passportNumber,
    this.gender,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });
}

abstract class CandidateStatisticsEntity extends BaseEntity {
  final int total;
  final int active;
  final ByStatus byStatus;

  CandidateStatisticsEntity({
    required super.rawJson,
    required this.total,
    required this.active,
    required this.byStatus,
  });
}

class ByStatus {
  final int applied;
  final int shortlisted;
  final int interviewScheduled;
  final int interviewRescheduled;
  final int interviewPassed;
  final int interviewFailed;
  final int withdrawn;

  const ByStatus({
    required this.applied,
    required this.shortlisted,
    required this.interviewScheduled,
    required this.interviewRescheduled,
    required this.interviewPassed,
    required this.interviewFailed,
    required this.withdrawn,
  });

  factory ByStatus.fromJson(Map<String, dynamic> json) {
    return ByStatus(
      applied: json['applied'] as int? ?? 0,
      shortlisted: json['shortlisted'] as int? ?? 0,
      interviewScheduled: json['interview_scheduled'] as int? ?? 0,
      interviewRescheduled: json['interview_rescheduled'] as int? ?? 0,
      interviewPassed: json['interview_passed'] as int? ?? 0,
      interviewFailed: json['interview_failed'] as int? ?? 0,
      withdrawn: json['withdrawn'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applied': applied,
      'shortlisted': shortlisted,
      'interview_scheduled': interviewScheduled,
      'interview_rescheduled': interviewRescheduled,
      'interview_passed': interviewPassed,
      'interview_failed': interviewFailed,
      'withdrawn': withdrawn,
    };
  }
}