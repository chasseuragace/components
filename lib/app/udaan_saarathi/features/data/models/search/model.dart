import '../../../domain/entities/search/entity.dart';
import 'package:openapi/src/model/agency_card_dto.dart' as api;

class SearchModel extends SearchEntity {
  SearchModel({
    required super.id,
    required super.name,
    required super.licenseNumber,
    super.logoUrl,
    super.description,
    super.city,
    super.country,
    super.website,
    required super.isActive,
    required super.createdAt,
    required super.jobPostingCount,
    super.specializations,
    required super.rawJson,
  });

  factory SearchModel.fromApiDto(api.AgencyCardDto dto) {
    return SearchModel(
      id: dto.id,
      name: dto.name,
      licenseNumber: dto.licenseNumber,
      logoUrl: dto.logoUrl,
      description: dto.description,
      city: dto.city,
      country: dto.country,
      website: dto.website,
      isActive: dto.isActive,
      createdAt: dto.createdAt,
      jobPostingCount: dto.jobPostingCount,
      specializations: dto.specializations,
      rawJson: dto.toJson(),
    );
  }

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      licenseNumber: json['license_number'] as String,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      city: json['city'],
      country: json['country'],
      website: json['website'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String,
      jobPostingCount: json['job_posting_count'] as int,
      specializations: json['specializations'] != null 
          ? List<String>.from(json['specializations'] as List)
          : null,
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'license_number': licenseNumber,
      'logo_url': logoUrl,
      'description': description,
      'city': city,
      'country': country,
      'website': website,
      'is_active': isActive,
      'created_at': createdAt,
      'job_posting_count': jobPostingCount,
      'specializations': specializations,
    };
  }
}
