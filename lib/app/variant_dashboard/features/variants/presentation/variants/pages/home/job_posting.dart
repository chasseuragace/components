import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/mobile_job_model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/homepage/job_position.dart';

class MobileJobEntity {
  final String id;
  final String postingTitle;
  final String country;
  final String city;
  final String agency;
  final String employer;
  final List<JobPosition>
      positions; // Each position has its own convertedSalary
  final String description;
  final ContractTerms contractTerms;
  final bool isActive;
  final DateTime postedDate;
  final String? preferencePriority;
  final String preferenceText;
  final String? location;
  final String? experience;
  final String? salary; // Display range (e.g., "AED 2500 - AED 2500")
  final String? type;
  final bool? isRemote;
  final bool? isFeatured;
  final String? companyLogo;
  final String? matchPercentage; // Skills alignment percentage (0-100)

  /// @deprecated Use positions[].convertedSalary instead
  /// Backend does not provide job-level converted salary, only position-level
  final String? convertedSalary;

  final int? applications;
  final String? policy;
  final String? manpowerPhone; // Phone number for contacting manpower/agency
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
    this.manpowerPhone,
  });
}
