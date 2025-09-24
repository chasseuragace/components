extension CompanyNameExtension on String {
  /// Returns the first character of the company name (capitalized)
  /// or "C" if the string is empty.
  String get companyInitial {
    if (trim().isEmpty) return "C"; // fallback if company name is empty
    return trim()[0].toUpperCase();
  }

  String get companyInitials {
    final parts = trim().split(RegExp(r"\s+")); // split by spaces
    if (parts.isEmpty || parts.first.isEmpty) return "C";

    // Take first char of first word
    String initials = parts[0][0].toUpperCase();

    // If there is a second word, take its first char too
    if (parts.length > 1 && parts[1].isNotEmpty) {
      initials += parts[1][0].toUpperCase();
    }

    return initials;
  }
}

extension RelativeTimeExtension on DateTime {
  /// Returns a human-readable relative time string like
  /// "just now", "5 mins ago", "2 days ago", "3 weeks ago"
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) {
      return "just now";
    } else if (diff.inMinutes < 60) {
      return diff.inMinutes == 1 ? "1 min ago" : "${diff.inMinutes} mins ago";
    } else if (diff.inHours < 24) {
      return diff.inHours == 1 ? "1 hour ago" : "${diff.inHours} hours ago";
    } else if (diff.inDays < 7) {
      return diff.inDays == 1 ? "1 day ago" : "${diff.inDays} days ago";
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return weeks == 1 ? "1 week ago" : "$weeks weeks ago";
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return months == 1 ? "1 month ago" : "$months months ago";
    } else {
      final years = (diff.inDays / 365).floor();
      return years == 1 ? "1 year ago" : "$years years ago";
    }
  }
}
