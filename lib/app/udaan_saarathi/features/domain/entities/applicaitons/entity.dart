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

/// Represents a job application entity with all its details
class ApplicaitonsEntity {
  /// Unique identifier for the application
  final String id;
  
  /// ID of the candidate who applied
  final String candidateId;
  
  /// ID of the job posting this application is for
  final String jobPostingId;
  
  /// Current status of the application
  final ApplicationStatus status;
  
  /// Name of the agency handling this application
  final String agencyName;
  
  /// Interview details if scheduled
  final InterviewEntity? interview;
  
  /// Details of the job posting
  final JobPostingEntity? jobPosting;
  
  /// When the application was submitted
  final DateTime appliedAt;
  
  /// When the application was last updated
  final DateTime updatedAt;
  
  /// Additional notes about the application
  final String? notes;
  
  /// Reference number for the application
  final String? referenceNumber;
  
  /// Any documents attached to the application
  final List<String>? documents;
  
  /// Any feedback received on the application
  final String? feedback;
  
  /// Rating given to the application (if any)
  final int? rating;
  
  /// Indicates if the application is archived
  final bool isArchived;

  /// Creates a new application entity
  const ApplicaitonsEntity({
    required this.id,
    required this.candidateId,
    required this.jobPostingId,
    required this.status,
    required this.agencyName,
    this.interview,
    this.jobPosting,
    required this.appliedAt,
    required this.updatedAt,
    this.notes,
    this.referenceNumber,
    this.documents,
    this.feedback,
    this.rating,
    this.isArchived = false,
  });
  
  /// Creates a copy of this application with the given fields replaced by the new values
  ApplicaitonsEntity copyWith({
    String? id,
    String? candidateId,
    String? jobPostingId,
    ApplicationStatus? status,
    String? agencyName,
    InterviewEntity? interview,
    JobPostingEntity? jobPosting,
    DateTime? appliedAt,
    DateTime? updatedAt,
    String? notes,
    String? referenceNumber,
    List<String>? documents,
    String? feedback,
    int? rating,
    bool? isArchived,
  }) {
    return ApplicaitonsEntity(
      id: id ?? this.id,
      candidateId: candidateId ?? this.candidateId,
      jobPostingId: jobPostingId ?? this.jobPostingId,
      status: status ?? this.status,
      agencyName: agencyName ?? this.agencyName,
      interview: interview ?? this.interview,
      jobPosting: jobPosting ?? this.jobPosting,
      appliedAt: appliedAt ?? this.appliedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      documents: documents ?? this.documents,
      feedback: feedback ?? this.feedback,
      rating: rating ?? this.rating,
      isArchived: isArchived ?? this.isArchived,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ApplicaitonsEntity &&
      other.id == id &&
      other.candidateId == candidateId &&
      other.jobPostingId == jobPostingId &&
      other.status == status &&
      other.agencyName == agencyName &&
      other.interview == interview &&
      other.jobPosting == jobPosting &&
      other.appliedAt == appliedAt &&
      other.updatedAt == updatedAt &&
      other.notes == notes &&
      other.referenceNumber == referenceNumber &&
      other.documents == documents &&
      other.feedback == feedback &&
      other.rating == rating &&
      other.isArchived == isArchived;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
      candidateId.hashCode ^
      jobPostingId.hashCode ^
      status.hashCode ^
      agencyName.hashCode ^
      interview.hashCode ^
      jobPosting.hashCode ^
      appliedAt.hashCode ^
      updatedAt.hashCode ^
      notes.hashCode ^
      referenceNumber.hashCode ^
      documents.hashCode ^
      feedback.hashCode ^
      rating.hashCode ^
      isArchived.hashCode;
  }
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
