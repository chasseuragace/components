import 'package:openapi/openapi.dart';
import '../../../domain/entities/notification/entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.candidateId,
    required super.jobApplicationId,
    required super.jobPostingId,
    required super.agencyId,
    super.interviewId,
    required super.notificationType,
    required super.title,
    required super.message,
    required super.payload,
    required super.isRead,
    required super.isSent,
    super.sentAt,
    super.readAt,
    required super.createdAt,
    required super.updatedAt,
    required super.rawJson,
  });

  factory NotificationModel.fromNotificationResponseDto(NotificationResponseDto dto) {
    return NotificationModel(
      id: dto.id,
      candidateId: dto.candidateId,
      jobApplicationId: dto.jobApplicationId,
      jobPostingId: dto.jobPostingId,
      agencyId: dto.agencyId,
      interviewId: dto.interviewId,
      notificationType: _parseNotificationTypeFromDto(dto.notificationType),
      title: dto.title,
      message: dto.message,
      payload: _parsePayloadFromObject(dto.payload),
      isRead: dto.isRead,
      isSent: dto.isSent,
      sentAt: dto.sentAt,
      readAt: dto.readAt,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      rawJson: dto.toJson(),
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      candidateId: json['candidate_id'] as String,
      jobApplicationId: json['job_application_id'] as String,
      jobPostingId: json['job_posting_id'] as String,
      agencyId: json['agency_id'] as String,
      interviewId: json['interview_id'] as String?,
      notificationType: _parseNotificationType(json['notification_type'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      payload: _parsePayload(json['payload'] as Map<String, dynamic>),
      isRead: json['is_read'] as bool,
      isSent: json['is_sent'] as bool,
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at'] as String) : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      rawJson: json,
    );
  }

  static NotificationType _parseNotificationTypeFromDto(NotificationResponseDtoNotificationTypeEnum dtoType) {
    switch (dtoType) {
      case NotificationResponseDtoNotificationTypeEnum.shortlisted:
        return NotificationType.shortlisted;
      case NotificationResponseDtoNotificationTypeEnum.interviewScheduled:
        return NotificationType.interviewScheduled;
      case NotificationResponseDtoNotificationTypeEnum.interviewRescheduled:
        return NotificationType.interviewRescheduled;
      case NotificationResponseDtoNotificationTypeEnum.interviewPassed:
        return NotificationType.interviewPassed;
      case NotificationResponseDtoNotificationTypeEnum.interviewFailed:
        return NotificationType.interviewFailed;
    }
  }

  static NotificationPayload _parsePayloadFromObject(Object payloadObject) {
    // Convert the Object to Map<String, dynamic>
    final payloadJson = payloadObject as Map<String, dynamic>;
    return _parsePayload(payloadJson);
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'shortlisted':
        return NotificationType.shortlisted;
      case 'interview_scheduled':
        return NotificationType.interviewScheduled;
      case 'interview_rescheduled':
        return NotificationType.interviewRescheduled;
      case 'interview_passed':
        return NotificationType.interviewPassed;
      case 'interview_failed':
        return NotificationType.interviewFailed;
      default:
        return NotificationType.shortlisted;
    }
  }

  static NotificationPayload _parsePayload(Map<String, dynamic> payloadJson) {
    return NotificationPayload(
      jobTitle: payloadJson['job_title'] as String,
      agencyName: payloadJson['agency_name'] as String,
      interviewDetails: payloadJson['interview_details'] != null
          ? InterviewDetails(
              date: payloadJson['interview_details']['date'] as String,
              time: payloadJson['interview_details']['time'] as String,
              location: payloadJson['interview_details']['location'] as String,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidate_id': candidateId,
      'job_application_id': jobApplicationId,
      'job_posting_id': jobPostingId,
      'agency_id': agencyId,
      'interview_id': interviewId,
      'notification_type': _notificationTypeToString(notificationType),
      'title': title,
      'message': message,
      'payload': _payloadToJson(payload),
      'is_read': isRead,
      'is_sent': isSent,
      'sent_at': sentAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static String _notificationTypeToString(NotificationType type) {
    switch (type) {
      case NotificationType.shortlisted:
        return 'shortlisted';
      case NotificationType.interviewScheduled:
        return 'interview_scheduled';
      case NotificationType.interviewRescheduled:
        return 'interview_rescheduled';
      case NotificationType.interviewPassed:
        return 'interview_passed';
      case NotificationType.interviewFailed:
        return 'interview_failed';
    }
  }

  static Map<String, dynamic> _payloadToJson(NotificationPayload payload) {
    return {
      'job_title': payload.jobTitle,
      'agency_name': payload.agencyName,
      'interview_details': payload.interviewDetails != null
          ? {
              'date': payload.interviewDetails!.date,
              'time': payload.interviewDetails!.time,
              'location': payload.interviewDetails!.location,
            }
          : null,
    };
  }
}

class NotificationListModel {
  final List<NotificationModel> items;
  final int total;
  final int page;
  final int limit;
  final int unreadCount;

  NotificationListModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.unreadCount,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    return NotificationListModel(
      items: (json['items'] as List<dynamic>)
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      unreadCount: json['unreadCount'] as int,
    );
  }
}
