import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';

class GroupedJobsModel extends GroupedJobsEntity {
  GroupedJobsModel({required List<JobGroupModel> groups}) : super(groups: groups);

  factory GroupedJobsModel.fromJson(Map<String, dynamic> json) {
    final groupsJson = (json['groups'] as List?) ?? const [];
    final groups = groupsJson
        .whereType<Map<String, dynamic>>()
        .map((g) => JobGroupModel.fromJson(g))
        .toList();
    return GroupedJobsModel(groups: groups);
  }

  Map<String, dynamic> toJson() {
    return {
      'groups': groups.map((g) => (g as JobGroupModel).toJson()).toList(),
    };
  }
}

class JobGroupModel extends JobGroupEntity {
  JobGroupModel({required String title, required List<GroupJobModel> jobs})
      : super(title: title, jobs: jobs);

  factory JobGroupModel.fromJson(Map<String, dynamic> json) {
    final jobsJson = (json['jobs'] as List?) ?? const [];
    final jobs = jobsJson
        .whereType<Map<String, dynamic>>()
        .map((j) => GroupJobModel.fromJson(j))
        .toList();
    return JobGroupModel(title: (json['title'] ?? '').toString(), jobs: jobs);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'jobs': jobs.map((j) => (j as GroupJobModel).toJson()).toList(),
    };
  }
}

class GroupJobModel extends GroupJobEntity {
  GroupJobModel({
    required String id,
    required String postingTitle,
    required String country,
    String? city,
    required List<String> primaryTitles,
    required SalarySummaryModel salary,
    required AgencyModel agency,
    required EmployerModel employer,
    DateTime? postingDateAd,
    String? cutoutUrl,
    required int fitnessScore,
    required dynamic positions,
  }) : super(
          id: id,
          postingTitle: postingTitle,
          country: country,
          city: city,
          primaryTitles: primaryTitles,
          salary: salary,
          agency: agency,
          employer: employer,
          postingDateAd: postingDateAd,
          cutoutUrl: cutoutUrl,
          fitnessScore: fitnessScore,
          positions: positions,
        );

  factory GroupJobModel.fromJson(Map<String, dynamic> json) {
    final primaryTitles = ((json['primary_titles'] as List?) ?? const [])
        .map((e) => e.toString())
        .toList();

    final salaryJson = (json['salary'] as Map?)?.cast<String, dynamic>() ?? {};
    final agencyJson = (json['agency'] as Map?)?.cast<String, dynamic>() ?? {};
    final employerJson = (json['employer'] as Map?)?.cast<String, dynamic>() ?? {};

    return GroupJobModel(
      positions: json['positions'],
      id: (json['id'] ?? '').toString(),
      postingTitle: (json['posting_title'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
      city: json['city']?.toString(),
      primaryTitles: primaryTitles,
      salary: SalarySummaryModel.fromJson(salaryJson),
      agency: AgencyModel.fromJson(agencyJson),
      employer: EmployerModel.fromJson(employerJson),
      postingDateAd: _parseDateTime(json['posting_date_ad']),
      cutoutUrl: json['cutout_url']?.toString(),
      fitnessScore: _asInt(json['fitness_score']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posting_title': postingTitle,
      'country': country,
      'city': city,
      'primary_titles': primaryTitles,
      'salary': (salary as SalarySummaryModel).toJson(),
      'agency': (agency as AgencyModel).toJson(),
      'employer': (employer as EmployerModel).toJson(),
      'posting_date_ad': postingDateAd?.toIso8601String(),
      'cutout_url': cutoutUrl,
      'fitness_score': fitnessScore,
    };
  }
}

class SalarySummaryModel extends SalarySummaryEntity {
  SalarySummaryModel({
    double? monthlyMin,
    double? monthlyMax,
    String? currency,
    required List<ConvertedAmountModel> converted,
  }) : super(
          monthlyMin: monthlyMin,
          monthlyMax: monthlyMax,
          currency: currency,
          converted: converted,
        );

  factory SalarySummaryModel.fromJson(Map<String, dynamic> json) {
    final convertedJson = (json['converted'] as List?) ?? const [];
    final converted = convertedJson
        .whereType<Map<String, dynamic>>()
        .map((c) => ConvertedAmountModel.fromJson(c))
        .toList();

    return SalarySummaryModel(
      monthlyMin: _asDouble(json['monthly_min']),
      monthlyMax: _asDouble(json['monthly_max']),
      currency: json['currency']?.toString(),
      converted: converted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly_min': monthlyMin,
      'monthly_max': monthlyMax,
      'currency': currency,
      'converted': converted.map((c) => (c as ConvertedAmountModel).toJson()).toList(),
    };
  }
}

class ConvertedAmountModel extends ConvertedAmountEntity {
  ConvertedAmountModel({required double amount, required String currency})
      : super(amount: amount, currency: currency);

  factory ConvertedAmountModel.fromJson(Map<String, dynamic> json) {
    return ConvertedAmountModel(
      amount: _asDouble(json['amount']) ?? 0,
      currency: (json['currency'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
    };
  }
}

class AgencyModel extends AgencyEntity {
  AgencyModel({String? name, String? licenseNumber})
      : super(name: name, licenseNumber: licenseNumber);

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      name: json['name']?.toString(),
      licenseNumber: json['license_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'license_number': licenseNumber,
    };
  }
}

class EmployerModel extends EmployerEntity {
  EmployerModel({String? companyName, String? country, String? city})
      : super(companyName: companyName, country: country, city: city);

  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      companyName: json['company_name']?.toString(),
      country: json['country']?.toString(),
      city: json['city']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'country': country,
      'city': city,
    };
  }
}

DateTime? _parseDateTime(dynamic value) {
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

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
