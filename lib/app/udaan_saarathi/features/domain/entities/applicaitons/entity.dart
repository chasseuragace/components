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

class ApplyJobDTOEntity {
  final String candidateId;
  final String jobPostingId;
  final String note;
  final String name;
  ApplyJobDTOEntity({
    required this.candidateId,
    required this.jobPostingId,
    required this.note,
    required this.name,
  });
}

class ApplicationPaginationWrapper {
  List<ApplicaitonsEntity> items;
  int? total, page, limit;

  ApplicationPaginationWrapper(
      {required this.items, this.total, this.page, this.limit});
}

class ApplicationDetailsEntity {
  final String id;
  final String candidateId;
  final String jobPostingId;
  final String status;
  final List<ApplicationHistoryEntity> historyBlob;
  final DateTime? withdrawnAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApplicationDetailsEntity({
    required this.id,
    required this.candidateId,
    required this.jobPostingId,
    required this.status,
    required this.historyBlob,
    this.withdrawnAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApplicationDetailsEntity &&
        other.id == id &&
        other.candidateId == candidateId &&
        other.jobPostingId == jobPostingId &&
        other.status == status &&
        _listEquals(other.historyBlob, historyBlob) &&
        other.withdrawnAt == withdrawnAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      candidateId,
      jobPostingId,
      status,
      Object.hashAll(historyBlob),
      withdrawnAt,
      createdAt,
      updatedAt,
    );
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class ApplicationHistoryEntity {
  final String? prevStatus;
  final String nextStatus;
  final DateTime updatedAt;
  final String? updatedBy;
  final String? note;

  ApplicationHistoryEntity({
    this.prevStatus,
    required this.nextStatus,
    required this.updatedAt,
    this.updatedBy,
    this.note,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApplicationHistoryEntity &&
        other.prevStatus == prevStatus &&
        other.nextStatus == nextStatus &&
        other.updatedAt == updatedAt &&
        other.updatedBy == updatedBy &&
        other.note == note;
  }

  @override
  int get hashCode {
    return Object.hash(
      prevStatus,
      nextStatus,
      updatedAt,
      updatedBy,
      note,
    );
  }
}
