
import '../../base_entity.dart';
import 'address.dart';

abstract class CandidateEntity extends BaseEntity {
  final String id;
  final String? fullName;
  final String? phone;
  final AddressEntity? address;
  final String? passportNumber;
  final String? gender;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CandidateEntity({
    required super.rawJson,
    required this.id,
    this.fullName,
    this.phone,
    this.address,
    this.passportNumber,
    this.gender,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });
}
