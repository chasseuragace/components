import 'package:variant_dashboard/app/udaan_saarathi/core/enum/application_status.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/mobile_job_model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/homepage/entity.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';

import '../../../domain/entities/applicaitons/entity.dart';

// class ApplicaitonsModel extends ApplicaitonsEntity {
//   ApplicaitonsModel({required super.id, this.name, required super.rawJson});

//   factory ApplicaitonsModel.fromJson(Map<String, dynamic> json) {
//     return ApplicaitonsModel(
//       id: json['id'] as String,
//         name: json['name'] as String?,
//         rawJson: json, // Pass the entire JSON object
//       );
//   }

//   final String? name;

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }

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

/// Model for paginated application results with JSON serialization
class ApplicationPaginationWrapperModel extends ApplicationPaginationWrapper {
  ApplicationPaginationWrapperModel({
    required super.items,
    super.total,
    super.page,
    super.limit,
  });

  factory ApplicationPaginationWrapperModel.fromJson(
      Map<String, dynamic> json) {
    return ApplicationPaginationWrapperModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => ApplicaitonsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => (e as ApplicaitonsModel).toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}

/// Model for ApplicationDetailsEntity with JSON serialization
class ApplicationDetailsModel extends ApplicationDetailsEntity {
  ApplicationDetailsModel({
    required super.id,
    required super.candidateId,
    required super.jobPostingId,
    required super.status,
    required super.historyBlob,
    super.withdrawnAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ApplicationDetailsModel.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailsModel(
      id: json['id'] as String,
      candidateId: json['candidate_id'] as String,
      jobPostingId: json['job_posting_id'] as String,
      status: json['status'] as String,
      historyBlob: (json['history_blob'] as List<dynamic>?)
              ?.map((e) =>
                  ApplicationHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      withdrawnAt: json['withdrawn_at'] != null
          ? DateTime.parse(json['withdrawn_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidate_id': candidateId,
      'job_posting_id': jobPostingId,
      'status': status,
      'history_blob': historyBlob
          .map((e) => (e as ApplicationHistoryModel).toJson())
          .toList(),
      'withdrawn_at': withdrawnAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Model for ApplicationHistoryEntity with JSON serialization
class ApplicationHistoryModel extends ApplicationHistoryEntity {
  ApplicationHistoryModel({
    super.prevStatus,
    required super.nextStatus,
    required super.updatedAt,
    super.updatedBy,
    super.note,
  });

  factory ApplicationHistoryModel.fromJson(Map<String, dynamic> json) {
    return ApplicationHistoryModel(
      prevStatus: json['prev_status'] as String?,
      nextStatus: json['next_status'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      updatedBy: json['updated_by'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prev_status': prevStatus,
      'next_status': nextStatus,
      'updated_at': updatedAt.toIso8601String(),
      'updated_by': updatedBy,
      'note': note,
    };
  }
}
