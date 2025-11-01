enum ApplicationStatus {
  applied,
  underReview,
  shortlisted,
  interviewScheduled,
  interviewRescheduled,
  interviewPassed,
  interviewFailed,
  accepted,
  rejected,
  withdrawn;

  /// Converts a string status from the backend to an ApplicationStatus enum value
  /// 
  /// Example:
  /// ```dart
  /// final status = ApplicationStatus.fromValue('interview_scheduled');
  /// print(status); // ApplicationStatus.interview_scheduled
  /// ```
  static ApplicationStatus fromValue(String? string) {
    if (string == null) return ApplicationStatus.applied;
    
    // First try direct match for backward compatibility
    try {
      return ApplicationStatus.values.firstWhere(
        (e) => e.name == string,
      );
    } catch (_) {
      // Try converting snake_case to camelCase for backward compatibility
      final normalizedString = string.toLowerCase();
      try {
        return ApplicationStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == normalizedString.replaceAll('_', '').toLowerCase(),
        );
      } catch (_) {
        // Fallback to case-insensitive match with underscores
        return ApplicationStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == normalizedString,
          orElse: () => ApplicationStatus.applied,
        );
      }
    }
  }
  
  /// Returns a human-readable string for the status
  String get displayName {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.interviewScheduled:
        return 'Interview Scheduled';
      case ApplicationStatus.interviewRescheduled:
        return 'Interview Rescheduled';
      case ApplicationStatus.interviewPassed:
        return 'Interview Passed';
      case ApplicationStatus.interviewFailed:
        return 'Interview Failed';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }
}
