
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/mobile_job_model.dart';

import 'domain/entities/home_screen_entity.dart';
import 'home_page_variant1.dart';

class MobileJobEntity {
  final String id;
  final String postingTitle;
  final String country;
  final String city;
  final String agency;
  final String employer;
  final List<JobPosition> positions;
  final String description;
  final ContractTerms contractTerms;
  final bool isActive;
  final DateTime postedDate;
  final String? preferencePriority;
  final String preferenceText;
  final String? location;
  final String? experience;
  final String? salary;
  final String? type;
  final bool? isRemote;
  final bool? isFeatured;
  final String? companyLogo;
  final String? matchPercentage;
  final String? convertedSalary;
  final int? applications;
  final String? policy;
  MobileJobEntity({
    required this.id,
    required this.postingTitle,
    required this.country,
    required this.city,
    required this.agency,
    required this.employer,
    required this.positions,
    required this.description,
    required this.contractTerms,
    this.isActive = true,
    required this.postedDate,
    this.preferencePriority,
    required this.preferenceText,
    this.location,
    this.experience,
    this.salary,
    this.type,
    this.isRemote,
    this.isFeatured,
    this.companyLogo,
    this.matchPercentage,
    this.convertedSalary,
    this.applications,
    this.policy,
  });
}
