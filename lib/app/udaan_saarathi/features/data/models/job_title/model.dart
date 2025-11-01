import '../../../domain/entities/job_title/entity.dart';

class JobTitle extends JobTitleEntity {
  final String category;

  JobTitle( {
    required super.id,
    super.rawJson = const {},
    super.createdAt,
    super.updatedAt,
   required super.title,
    super.rank,
   required super.isActive,
    super.difficulty,
    super.skillsSummary,
    super.description,  this. category= 'All Categories',
  });

  factory JobTitle.fromJson(Map<String, dynamic> json) {
    return JobTitle(
      id: json['id'] as String,
      rawJson: json,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      title: json['title'] as String,
      rank: json['rank'] is int
          ? json['rank'] as int
          : (json['rank'] is num ? (json['rank'] as num).toInt() : null),
      isActive: json['is_active'] as bool,
      difficulty: json['difficulty'] as String?,
      skillsSummary: json['skills_summary'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'title': title,
      'rank': rank,
      'is_active': isActive,
      'difficulty': difficulty,
      'skills_summary': skillsSummary,
      'description': description,
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
