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
