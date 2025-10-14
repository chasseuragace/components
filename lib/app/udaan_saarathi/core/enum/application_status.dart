enum ApplicationStatus {
  applied,
  underReview,
  interviewScheduled,
  interviewRescheduled,
  interviewPassed,
  interviewFailed,
  withdrawn,
  rejected,
  accepted;

  static ApplicationStatus fromValue(String? string) {
    if (string == null) return ApplicationStatus.applied;
    return ApplicationStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == string.toLowerCase(),
      orElse: () => ApplicationStatus.applied,
    );
  }
}
