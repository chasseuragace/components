
import '../../base_entity.dart';

abstract class SearchEntity extends BaseEntity {
  final String id;
  final String name;
  final String licenseNumber;
  final String? logoUrl;
  final String? description;
  final dynamic city;
  final dynamic country;
  final String? website;
  final bool isActive;
  final String createdAt;
  final int jobPostingCount;
  final List<String>? specializations;
  
  SearchEntity({
    required super.rawJson,
    required this.id,
    required this.name,
    required this.licenseNumber,
    this.logoUrl,
    this.description,
    this.city,
    this.country,
    this.website,
    required this.isActive,
    required this.createdAt,
    required this.jobPostingCount,
    this.specializations,
  });
}
