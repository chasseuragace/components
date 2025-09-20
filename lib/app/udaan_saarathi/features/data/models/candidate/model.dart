import '../../../domain/entities/candidate/entity.dart';
import '../../../domain/entities/candidate/address.dart';

class CandidateModel extends CandidateEntity {
  CandidateModel({
    required super.id,
    required super.rawJson,
    super.fullName,
    super.phone,
    super.address,
    super.passportNumber,
    super.gender,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] is Map<String, dynamic>
          ? AddressEntity.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      passportNumber: json['passport_number'] as String?,
      gender: json['gender'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'address': address?.toJson(),
      'passport_number': passportNumber,
      'gender': gender,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class CandidateStatisticsModel extends CandidateStatisticsEntity {
  CandidateStatisticsModel({
    required super.total,
    required super.active,
    required super.byStatus,
    required super.rawJson,
  });

  factory CandidateStatisticsModel.fromJson(Map<String, dynamic> json) {
    return CandidateStatisticsModel(
      total: json['total'] as int,
      active: json['active'] as int,
      byStatus: ByStatus.fromJson(json['by_status'] as Map<String, dynamic>),
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'active': active,
      'by_status': byStatus.toJson(),
    };
  }
}
