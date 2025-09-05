import 'package:flutter/material.dart';

class InterviewSchedule {
  final String jobTitle;
  final String companyName;
  final String companyLogo;
  final String interviewType;
  final String interviewRound;
  final DateTime dateTime;
  final String duration;
  final String location;
  final String interviewer;
  final String interviewerRole;
  final String status;
  final String priority;
  final String salaryRange;
  final Color statusColor;
  final IconData statusIcon;

  InterviewSchedule({
    required this.jobTitle,
    required this.companyName,
    required this.companyLogo,
    required this.interviewType,
    required this.interviewRound,
    required this.dateTime,
    required this.duration,
    required this.location,
    required this.interviewer,
    required this.interviewerRole,
    required this.status,
    required this.priority,
    required this.salaryRange,
    required this.statusColor,
    required this.statusIcon,
  });
}
