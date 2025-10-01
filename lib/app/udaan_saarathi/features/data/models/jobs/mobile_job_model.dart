import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';


class ContractTerms {
  final String type;
  final String duration;
  final String? salary;           // Optional: e.g., "50000-70000"
  final bool? isRenewable;        // Optional: Whether the contract can be renewed
  final String? noticePeriod;     // Optional: e.g., "1 month"
  final String? workingHours;     // Optional: e.g., "40 hours/week"
  final String? probationPeriod;  // Optional: e.g., "3 months"
  final String? benefits;         // Optional: Comma-separated benefits

  const ContractTerms({
    required this.type,
    required this.duration,
    this.salary,
    this.isRenewable,
    this.noticePeriod,
    this.workingHours,
    this.probationPeriod,
    this.benefits,
  });

  // Factory constructor from JSON
factory ContractTerms.fromJson(Map<String, dynamic> json) {
  return ContractTerms(
    type: json['type'] as String? ?? 'Full-time',
    duration: json['duration'] as String? ?? 'Not specified',
    salary: json['salary'] as String? ?? 'Not specified',
    isRenewable: json['isRenewable'] as bool? ?? false,
    noticePeriod: json['noticePeriod'] as String? ?? 'Not specified',
    workingHours: json['workingHours'] as String? ?? 'Not specified',
    probationPeriod: json['probationPeriod'] as String? ?? 'Not specified',
    benefits: json['benefits'] as String? ?? 'None',
  );
}


  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration': duration,
      if (salary != null) 'salary': salary,
      if (isRenewable != null) 'isRenewable': isRenewable,
      if (noticePeriod != null) 'noticePeriod': noticePeriod,
      if (workingHours != null) 'workingHours': workingHours,
      if (probationPeriod != null) 'probationPeriod': probationPeriod,
      if (benefits != null) 'benefits': benefits,
    };
  }

  // Copy with method for immutability
  ContractTerms copyWith({
    String? type,
    String? duration,
    String? salary,
    bool? isRenewable,
    String? noticePeriod,
    String? workingHours,
    String? probationPeriod,
    String? benefits,
  }) {
    return ContractTerms(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      salary: salary ?? this.salary,
      isRenewable: isRenewable ?? this.isRenewable,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      workingHours: workingHours ?? this.workingHours,
      probationPeriod: probationPeriod ?? this.probationPeriod,
      benefits: benefits ?? this.benefits,
    );
  }

  // Override toString for debugging
  @override
  String toString() {
    return 'ContractTerms('
        'type: $type, '
        'duration: $duration, '
        'salary: $salary, '
        'isRenewable: $isRenewable, '
        'noticePeriod: $noticePeriod, '
        'workingHours: $workingHours, '
        'probationPeriod: $probationPeriod, '
        'benefits: $benefits)';
  }

  // Helper methods
  bool get hasProbation => probationPeriod != null;
  bool get isPermanent => type.toLowerCase().contains('permanent');
  bool isContractType(String typeToCheck) => 
      type.toLowerCase() == typeToCheck.toLowerCase();
}
// ✅ JobPosition Model
class JobPositionModel extends JobPosition {
  JobPositionModel({
    required super.id,
    required super.title,
    super.baseSalary,
    super.convertedSalary,
    super.currency,
    super.requirements,
  });

 factory JobPositionModel.fromJson(Map<String, dynamic> json) {
  return JobPositionModel(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? 'Untitled Position',
    baseSalary: json['baseSalary'] as String? ?? 'Not specified',
    convertedSalary: json['convertedSalary'] as String? ?? 'Not available',
    currency: json['currency'] as String? ?? 'N/A',
    requirements: (json['requirements'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'baseSalary': baseSalary,
      'convertedSalary': convertedSalary,
      'currency': currency,
      'requirements': requirements,
    };
  }
}

// ✅ MobileJob Model
class MobileJobModel extends MobileJobEntity {
  MobileJobModel({
    required super.id,
    required super.postingTitle,
    required super.country,
    required super.city,
    required super.agency,
    required super.employer,
    required List<JobPositionModel> super.positions,
    required super.description,
    required ContractTerms super.contractTerms,
    super.isActive = true,
    required super.postedDate,
    super.preferencePriority,
    required super.preferenceText,
    super.location,
    super.experience,
    super.salary,
    super.type,
    super.isRemote,
    super.isFeatured,
    super.companyLogo,
    super.matchPercentage,
    super.convertedSalary,
    super.applications,
    super.policy,
  });

factory MobileJobModel.fromJson(Map<String, dynamic> json) {
  return MobileJobModel(
    id: json['id'] as String? ?? '',
    postingTitle: json['postingTitle'] as String? ?? 'Untitled Job',
    country: json['country'] as String? ?? 'Unknown',
    city: json['city'] as String? ?? 'Unknown',
    agency: json['agency'] as String? ?? 'Unknown',
    employer: json['employer'] as String? ?? 'Unknown',
    positions: (json['positions'] as List<dynamic>?)
            ?.map((e) => JobPositionModel.fromJson(e))
            .toList() ??
        [],
    description: json['description'] as String? ?? 'No description provided',
    contractTerms: ContractTerms.fromJson(
        json['contractTerms'] as Map<String, dynamic>? ?? {}),
    isActive: json['isActive'] as bool? ?? true,
    postedDate: json['postedDate'] != null
        ? DateTime.parse(json['postedDate'] as String)
        : DateTime.now(),
    preferencePriority: json['preferencePriority'] as String? ?? 'Normal',
    preferenceText: json['preferenceText'] as String? ?? 'N/A',
    location: json['location'] as String? ?? 'Not specified',
    experience: json['experience'] as String? ?? 'Not specified',
    salary: json['salary'] as String? ?? 'Not specified',
    type: json['type'] as String? ?? 'Full-time',
    isRemote: json['isRemote'] as bool? ?? false,
    isFeatured: json['isFeatured'] as bool? ?? false,
    companyLogo: json['companyLogo'] as String? ?? '',
    matchPercentage: json['matchPercentage'] as String? ?? '0',
    // Note: Backend doesn't provide job-level convertedSalary, only position-level
    // This field will typically be null - use positions[].convertedSalary instead
    convertedSalary: json['convertedSalary'] as String?,
    applications: json['applications'] as int? ?? 0,
    policy: json['policy'] as String? ?? 'Standard',
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postingTitle': postingTitle,
      'country': country,
      'city': city,
      'agency': agency,
      'employer': employer,
      'positions': positions.map((e) => (e as JobPositionModel).toJson()).toList(),
      'description': description,
      'contractTerms': contractTerms.toJson(),
      'isActive': isActive,
      'postedDate': postedDate.toIso8601String(),
      'preferencePriority': preferencePriority,
      'preferenceText': preferenceText,
      'location': location,
      'experience': experience,
      'salary': salary,
      'type': type,
      'isRemote': isRemote,
      'isFeatured': isFeatured,
      'companyLogo': companyLogo,
      'matchPercentage': matchPercentage,
      'convertedSalary': convertedSalary,
      'applications': applications,
      'policy': policy,
    };
  }
}
