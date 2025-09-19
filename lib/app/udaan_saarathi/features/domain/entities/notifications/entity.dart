import '../../base_entity.dart';

abstract class NotificationsEntity extends BaseEntity {
  final String id;
  NotificationsEntity({
    // TODO : Notifications : Define params
    required super.rawJson,
    required this.id,
  });
}

enum NotificationStatus { shortlisted, rejected, underReview, interview }

class JobNotificationEntity {
  final String jobTitle;
  final String companyName;
  final NotificationStatus status;
  final String timestamp;
  final String companyLogo;
  final DateTime? interviewDate;
  final String? interviewTime;
  final String? interviewLocation;
  final String? meetingLink;
  final String interviewType;
  final List<String> requirements;
  final String interviewDetails;
  final String? recruiterName;
  final String? recruiterEmail;
  final String? recruiterPhone;
  final bool isNew;
  final String? description;

  JobNotificationEntity({
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.timestamp,
    required this.companyLogo,
    this.interviewDate,
    this.interviewTime,
    this.interviewLocation,
    this.meetingLink,
    this.interviewType = 'Initial Round',
    this.requirements = const [],
    this.interviewDetails = '',
    this.recruiterName,
    this.recruiterEmail,
    this.recruiterPhone,
    this.isNew = false,
    this.description,
  });
}

final List<JobNotificationEntity> notifications = [
  JobNotificationEntity(
    jobTitle: 'Electrician',
    companyName: 'GulfBuild LLC (Dubai, UAE)',
    status: NotificationStatus.shortlisted,
    timestamp: '2 hours ago',
    companyLogo: 'G',
    interviewDate: DateTime.now().add(Duration(days: 3)),
    interviewTime: '10:00 AM - 11:00 AM',
    interviewLocation: 'GulfBuild Workshop, Al Quoz, Dubai',
    meetingLink: 'https://meet.google.com/elec-round-1',
    interviewType: 'Trade Test & Safety Briefing',
    requirements: [
      'Updated Resume',
      'Passport Copy',
      'Trade Certificate',
      'Safety Shoes & Gloves'
    ],
    interviewDetails:
        'Hands-on wiring test (conduits, DB termination) and basic HSE orientation. Bring your original certificates for verification.',
    recruiterName: 'Ahmed Khan',
    recruiterEmail: 'ahmed.khan@gulfbuild.ae',
    recruiterPhone: '+971 50 123 4567',
    description:
        'Hands-on wiring test (conduits, DB termination) and basic HSE orientation. Bring your original certificates for verification.',
  ),
  JobNotificationEntity(
    jobTitle: 'Plumber',
    companyName: 'Doha Maintenance Co. (Doha, Qatar)',
    status: NotificationStatus.underReview,
    timestamp: '1 day ago',
    companyLogo: 'D',
    interviewDate: DateTime.now().add(Duration(days: 5)),
    interviewTime: '2:00 PM - 3:30 PM',
    interviewLocation: 'Online Interview',
    meetingLink: 'https://zoom.us/j/987654321',
    interviewType: 'Experience Screening',
    requirements: ['Passport Copy', 'Recent Photo', 'Work Portfolio (if any)'],
    interviewDetails:
        'Discussion on PPR/CPVC installation, pressure testing, and maintenance workflows for residential towers.',
    recruiterName: 'Fatima Al-Thani',
    recruiterEmail: 'fatima@dohamaintenance.qa',
    description:
        'Discussion on PPR/CPVC installation, pressure testing, and maintenance workflows for residential towers.',
  ),
  JobNotificationEntity(
    jobTitle: 'Heavy Vehicle Driver',
    companyName: 'Riyadh Logistics (Riyadh, Saudi Arabia)',
    status: NotificationStatus.rejected,
    timestamp: '3 days ago',
    companyLogo: 'R',
    interviewDetails:
        'Thank you for applying. At this time, priority was given to candidates with GCC Heavy License and ADR certification.',
    description:
        'Thank you for applying. At this time, priority was given to candidates with GCC Heavy License and ADR certification.',
  ),
];
