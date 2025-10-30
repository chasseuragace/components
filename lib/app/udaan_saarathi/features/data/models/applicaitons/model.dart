import 'package:variant_dashboard/app/udaan_saarathi/core/enum/application_status.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/mobile_job_model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/homepage/entity.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';

import '../../../domain/entities/applicaitons/entity.dart';


/// Model for ApplicationEntity with JSON serialization
class ApplicaitonsModel extends ApplicaitonsEntity {
  ApplicaitonsModel({
    required super.id,
    required super.candidateId,
    required super.jobPostingId,
    required super.status,
    required super.updatedBy,
    required super.appliedAt,
    required super.posting,
    required super.interviewDetail,
  });

  factory ApplicaitonsModel.fromJson(Map<String, dynamic> json) {
    return ApplicaitonsModel(
      id: json['id'] as String,
      candidateId: json['candidate_id'] as String,
      jobPostingId: json['job_posting_id'] as String,
      status: ApplicationStatus.fromValue(json['status'] as String),
      updatedBy: json['updated_by'] as String?,
      appliedAt: json['created_at'],
      posting: MobileJobEntity(
        id: 'post_003',
        postingTitle: 'Hospitality Staff Recruitment - Multiple Roles',
        country: 'Qatar',
        city: 'Doha',
        agency: 'Gulf Hospitality Agency',
        employer: 'Doha Grand Hotel',
        description:
            'Hiring skilled hospitality staff for hotel operations and customer service.',
        contractTerms: ContractTerms(duration: '1 year', type: 'Full-time'),
        postedDate: DateTime.now().subtract(Duration(days: 7)),
        preferenceText: 'Electrician',
        positions: [],
      ),
      interviewDetail: InterviewDetail(
        id: 'int_001',
        scheduledAt: DateTime.now().add(Duration(days: 3)),
        location: 'Lakeside, Pokhara',
        contact: 'HR Team - +977-61-123456',
        notes: 'Interview with the founding team',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate_id': candidateId,
      'job_posting_id': jobPostingId,
      'note': status,
      'updated_by': updatedBy,
    };
  }
}

