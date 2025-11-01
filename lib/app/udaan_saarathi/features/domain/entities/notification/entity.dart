import '../../base_entity.dart';

enum NotificationType {
  shortlisted,
  interviewScheduled,
  interviewRescheduled,
  interviewPassed,
  interviewFailed,
}

class NotificationPayload {
  final String jobTitle;
  final String agencyName;
  final InterviewDetails? interviewDetails;

  NotificationPayload({
    required this.jobTitle,
    required this.agencyName,
    this.interviewDetails,
  });
}

class InterviewDetails {
  final String date;
  final String time;
  final String location;

  InterviewDetails({
    required this.date,
    required this.time,
    required this.location,
  });
}

abstract class NotificationEntity extends BaseEntity {
  final String id;
  final String candidateId;
  final String jobApplicationId;
  final String jobPostingId;
  final String agencyId;
  final String? interviewId;
  final NotificationType notificationType;
  final String title;
  final String message;
  final NotificationPayload payload;
  final bool isRead;
  final bool isSent;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationEntity({
    required super.rawJson,
    required this.id,
    required this.candidateId,
    required this.jobApplicationId,
    required this.jobPostingId,
    required this.agencyId,
    this.interviewId,
    required this.notificationType,
    required this.title,
    required this.message,
    required this.payload,
    required this.isRead,
    required this.isSent,
    this.sentAt,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
