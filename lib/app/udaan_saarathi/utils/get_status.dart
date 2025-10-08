import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/application_status.dart';

Color getStatusColor(ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.applied:
      return AppColors.primaryColor;
    case ApplicationStatus.underReview:
      return Color(0xFFF59E0B);
    case ApplicationStatus.interviewScheduled:
    case ApplicationStatus.interviewRescheduled:
      return Color(0xFF10B981);
    case ApplicationStatus.interviewPassed:
    case ApplicationStatus.accepted:
      return Color(0xFF059669);
    case ApplicationStatus.interviewFailed:
    case ApplicationStatus.rejected:
    case ApplicationStatus.withdrawn:
      return Color(0xFFEF4444);
    default:
      return Color(0xFF6B7280);
  }
}

IconData getStatusIcon(ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.applied:
      return Icons.send_rounded;
    case ApplicationStatus.underReview:
      return Icons.visibility_rounded;
    case ApplicationStatus.interviewScheduled:
    case ApplicationStatus.interviewRescheduled:
      return Icons.event_rounded;
    case ApplicationStatus.interviewPassed:
    case ApplicationStatus.accepted:
      return Icons.check_circle_rounded;
    case ApplicationStatus.interviewFailed:
    case ApplicationStatus.rejected:
    case ApplicationStatus.withdrawn:
      return Icons.cancel_rounded;
    default:
      return Icons.help_rounded;
  }
}

String getStatusText(ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.applied:
      return 'Applied';
    case ApplicationStatus.underReview:
      return 'Under Review';
    case ApplicationStatus.interviewScheduled:
      return 'Interview Scheduled';
    case ApplicationStatus.interviewRescheduled:
      return 'Interview Rescheduled';
    case ApplicationStatus.interviewPassed:
      return 'Interview Passed';
    case ApplicationStatus.interviewFailed:
      return 'Interview Failed';
    case ApplicationStatus.withdrawn:
      return 'Withdrawn';
    case ApplicationStatus.rejected:
      return 'Rejected';
    case ApplicationStatus.accepted:
      return 'Accepted';
  }
}

 bool canWithdraw(ApplicationStatus status) {
    return status == ApplicationStatus.applied ||
        status == ApplicationStatus.underReview ||
        status == ApplicationStatus.interviewScheduled ||
        status == ApplicationStatus.interviewRescheduled;
  }