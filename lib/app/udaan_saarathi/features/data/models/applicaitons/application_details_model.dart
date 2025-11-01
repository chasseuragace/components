import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_details_entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';

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
