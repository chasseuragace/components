
import '../../base_entity.dart';
/*
{
      "id": "bb5b4e32-0dfa-4796-a79e-02451168ebdb",
      "created_at": "2025-09-12T07:24:23.925Z",
      "updated_at": "2025-09-12T07:24:23.925Z",
      "title": "Mason",
      "rank": 1,
      "is_active": true,
      "difficulty": "High",
      "skills_summary": "Basic masonry, site experience",
      "description": "Lays bricks/blocks, builds walls, plastering. Heavy lifting outdoors."
    },*/
abstract class JobTitleEntity extends BaseEntity {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final int? rank;
  final bool? isActive;
  final String? difficulty;
  final String? skillsSummary;
  final String? description;

  JobTitleEntity({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.rank,
    this.isActive,
    this.difficulty,
    this.skillsSummary,
    this.description,
    required super.rawJson,
  });
}

