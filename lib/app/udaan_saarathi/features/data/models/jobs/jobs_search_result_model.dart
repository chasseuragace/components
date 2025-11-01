import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/model.dart';

import '../../../domain/entities/jobs/jobs_search_results.dart';

/// Model representing converted salary information with JSON serialization
class ConvertedSalaryModel extends ConvertedSalary {
  const ConvertedSalaryModel({
    required super.amount,
    required super.currency,
  });

  factory ConvertedSalaryModel.fromJson(Map<String, dynamic> json) {
    return ConvertedSalaryModel(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
    };
  }
}

/// Model representing salary information with JSON serialization
class SalaryModel extends Salary {
  const SalaryModel({
    required super.monthlyAmount,
    required super.currency,
    required super.converted,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      monthlyAmount: (json['monthly_amount'] as num).toDouble(),
      currency: json['currency'] as String,
      converted: (json['converted'] as List<dynamic>)
          .map((e) => ConvertedSalaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly_amount': monthlyAmount,
      'currency': currency,
      'converted':
          converted.map((e) => (e as ConvertedSalaryModel).toJson()).toList(),
    };
  }
}

/// Model representing job vacancies with JSON serialization
class VacanciesModel extends Vacancies {
  const VacanciesModel({
    required super.male,
    required super.female,
    required super.total,
  });

  factory VacanciesModel.fromJson(Map<String, dynamic> json) {
    return VacanciesModel(
      male: json['male'] as int,
      female: json['female'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'male': male,
      'female': female,
      'total': total,
    };
  }
}

/// Model representing a job position with JSON serialization
class PositionModel extends Position {
  const PositionModel({
    required super.title,
    required super.vacancies,
    required super.salary,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      title: json['title'] as String,
      vacancies:
          VacanciesModel.fromJson(json['vacancies'] as Map<String, dynamic>),
      salary: SalaryModel.fromJson(json['salary'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'vacancies': (vacancies as VacanciesModel).toJson(),
      'salary': (salary as SalaryModel).toJson(),
    };
  }
}

/// Model representing an agency with JSON serialization
class AgencyModel extends Agency {
  const AgencyModel({
    required super.name,
    required super.licenseNumber,
  });

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      name: json['name'] as String,
      licenseNumber: json['license_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'license_number': licenseNumber,
    };
  }
}

/// Model representing an employer with JSON serialization
class EmployerModel extends Employer {
  const EmployerModel({
    required super.companyName,
    required super.country,
    required super.city,
  });

  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      companyName: json['company_name'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
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

/// Model representing job search results with JSON serialization
class JobsSearchResultsModel extends JobsSearchResults {
  const JobsSearchResultsModel({
    required super.id,
    required super.postingTitle,
    required super.country,
    required super.city,
    required super.postingDateAd,
    required super.employer,
    required super.agency,
    required super.positions,
  });

  factory JobsSearchResultsModel.fromJson(Map<String, dynamic> json) {
    return JobsSearchResultsModel(
      id: json['id'] as String,
      postingTitle: json['posting_title'] as String,
      country: json['country'] as String,
      city: json['city'] ?? "",
      postingDateAd: DateTime.parse(json['posting_date_ad'] as String),
      employer:
          EmployerModel.fromJson(json['employer'] as Map<String, dynamic>),
      agency: AgencyModel.fromJson(json['agency'] as Map<String, dynamic>),
      positions: (json['positions'] as List<dynamic>)
          .map((e) => PositionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posting_title': postingTitle,
      'country': country,
      'city': city,
      'posting_date_ad':
          postingDateAd.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'employer': (employer as EmployerModel).toJson(),
      'agency': (agency as AgencyModel).toJson(),
      'positions': positions.map((e) => (e as PositionModel).toJson()).toList(),
    };
  }
}

/// Model representing paginated jobs search results with JSON serialization
class PaginatedJobsSearchResultsModel extends PaginatedJobsSearchResults {
  const PaginatedJobsSearchResultsModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory PaginatedJobsSearchResultsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedJobsSearchResultsModel(
      data: (json['data'] as List<dynamic>)
          .map(
              (e) => JobsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => (e as JobsSearchResultsModel).toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}
