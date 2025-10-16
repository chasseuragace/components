import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/notifications/entity.dart';

// Enhanced JobNotification model

// Main App

// Page 2: Notification Detail
class NotificationDetailPage extends StatelessWidget {
  final JobNotificationEntity notification;

  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Notification Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            if (notification.status == NotificationStatus.shortlisted) ...[
              _buildInterviewDetailsCard(),
              const SizedBox(height: 16),
              _buildRequirementsCard(),
              const SizedBox(height: 16),
              _buildContactCard(),
              const SizedBox(height: 24),
              _buildActionButton(context),
            ] else if (notification.status ==
                NotificationStatus.underReview) ...[
              _buildStatusCard(),
            ] else ...[
              _buildRejectionCard(),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor(notification.status)
                          .withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getStatusColor(notification.status)
                          .withValues(alpha: 0.2),
                      _getStatusColor(notification.status)
                          .withValues(alpha: 0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    notification.companyName.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(notification.status),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.jobTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.companyName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(notification.status).withOpacity(0.9),
                  _getStatusColor(notification.status),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(notification.status).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _getStatusText(notification.status),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewDetailsCard() {
    return _buildCard(
      title: 'Interview Details',
      icon: Icons.calendar_today_rounded,
      children: [
        _buildDetailRow(
            Icons.event, 'Date', _formatDate(notification.interviewDate!)),
        _buildDetailRow(
            Icons.access_time, 'Time', notification.interviewTime ?? ''),
        _buildDetailRow(Icons.video_call, 'Type', notification.interviewType),
        if (notification.interviewLocation != null)
          _buildDetailRow(
              Icons.location_on, 'Location', notification.interviewLocation!),
        if (notification.meetingLink != null)
          _buildDetailRow(
              Icons.link, 'Meeting Link', notification.meetingLink!),
        if (notification.interviewDetails.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            notification.interviewDetails,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRequirementsCard() {
    if (notification.requirements.isEmpty) return const SizedBox();

    return _buildCard(
      title: 'Requirements',
      icon: Icons.checklist_rounded,
      children: [
        ...notification.requirements.map((req) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      req,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary2,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildContactCard() {
    if (notification.recruiterName == null) return const SizedBox();

    return _buildCard(
      title: 'Contact Information',
      icon: Icons.person_rounded,
      children: [
        _buildDetailRow(Icons.person, 'Recruiter', notification.recruiterName!),
        if (notification.recruiterEmail != null)
          _buildDetailRow(Icons.email, 'Email', notification.recruiterEmail!),
        if (notification.recruiterPhone != null)
          _buildDetailRow(Icons.phone, 'Phone', notification.recruiterPhone!),
      ],
    );
  }

  Widget _buildStatusCard() {
    return _buildCard(
      title: 'Application Status',
      icon: Icons.hourglass_empty_rounded,
      children: [
        const Text(
          'Your application is currently under review. We will notify you once there are any updates.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRejectionCard() {
    return _buildCard(
      title: 'Application Update',
      icon: Icons.info_outline_rounded,
      children: [
        Text(
          notification.interviewDetails.isEmpty
              ? 'Thank you for your interest in this position. We have decided to move forward with other candidates.'
              : notification.interviewDetails,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: const Color(0xFF667EEA)),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary2,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33667EEA),
              blurRadius: 16,
              offset: Offset(0, 8),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to calendar successfully!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            child: const Center(
              child: Text(
                'Add to Calendar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
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
        return const Color(0xFF8B5CF6);
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

// Entry point
