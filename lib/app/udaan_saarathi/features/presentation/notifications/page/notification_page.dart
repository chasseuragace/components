import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/notifications/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/applicaitons/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/notification_detail/notification_detail_page.dart';

class JobNotificationsPage extends StatelessWidget {
  const JobNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: NotificationsList(),
    );
  }
}

class NotificationsList extends StatelessWidget {
  NotificationsList({super.key});

  final List<JobNotificationEntity> notificationsList = [
    JobNotificationEntity(
      jobTitle: 'Electrician',
      companyName: 'GulfBuild LLC (Dubai, UAE)',
      status: NotificationStatus.shortlisted,
      timestamp: '2 hours ago',
      companyLogo: 'G',
    ),
    JobNotificationEntity(
      jobTitle: 'Plumber',
      companyName: 'Doha Maintenance Co. (Doha, Qatar)',
      status: NotificationStatus.underReview,
      timestamp: '5 hours ago',
      companyLogo: 'D',
    ),
    JobNotificationEntity(
      jobTitle: 'Heavy Vehicle Driver',
      companyName: 'Riyadh Logistics (Riyadh, Saudi Arabia)',
      status: NotificationStatus.rejected,
      timestamp: '1 day ago',
      companyLogo: 'R',
    ),
    JobNotificationEntity(
      jobTitle: 'Welder (Arc/MIG)',
      companyName: 'Bahrain Steelworks (Manama, Bahrain)',
      status: NotificationStatus.shortlisted,
      timestamp: '2 days ago',
      companyLogo: 'B',
    ),
    JobNotificationEntity(
      jobTitle: 'AC Technician',
      companyName: 'Kuwait Cooling Solutions (Kuwait City, Kuwait)',
      status: NotificationStatus.underReview,
      timestamp: '3 days ago',
      companyLogo: 'K',
    ),
  ];

  @override
  Widget build(BuildContext context) {

    // Uncomment the line below to show empty state
    // return const EmptyNotificationsState();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NotificationCard(notification: notifications[index]),
        );
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  final JobNotificationEntity notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  notification.companyLogo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Title
                  Text(
                    notification.jobTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Company Name
                  Text(
                    notification.companyName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Status and Timestamp Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(notification.status)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getStatusText(notification.status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(notification.status),
                          ),
                        ),
                      ),

                      // Timestamp
                      Text(
                        notification.timestamp,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.shortlisted:
        return const Color(0xFF10B981);
      case NotificationStatus.rejected:
        return const Color(0xFFEF4444);
      case NotificationStatus.underReview:
        return const Color(0xFFF59E0B);
      case NotificationStatus.interview:
        return const Color(0xFF10B981);
    }
  }

  String _getStatusText(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.shortlisted:
        return 'Shortlisted';
      case NotificationStatus.rejected:
        return 'Rejected';
      case NotificationStatus.underReview:
        return 'Under Review';
      case NotificationStatus.interview:
        return 'Interview';
    }
  }
}

class EmptyNotificationsState extends StatelessWidget {
  const EmptyNotificationsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 60,
                color: Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),

            // Description
            const Text(
              'You\'ll receive notifications about your\njob applications here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
// class JobNotification {
//   final String jobTitle;
//   final String companyName;
//   final NotificationStatus status;
//   final String timestamp;
//   final String companyLogo;

//   const JobNotification({
//     required this.jobTitle,
//     required this.companyName,
//     required this.status,
//     required this.timestamp,
//     required this.companyLogo,
//   });
// }

// enum NotificationStatus {
//   shortlisted,
//   rejected,
//   underReview,
// }

// // Usage Example
