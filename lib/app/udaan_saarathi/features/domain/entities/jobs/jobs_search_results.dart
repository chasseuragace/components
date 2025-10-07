import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity.dart';

/// Entity representing converted salary information
class ConvertedSalary {
  final double amount;
  final String currency;

  const ConvertedSalary({
    required this.amount,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConvertedSalary &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currency == other.currency;

  @override
  int get hashCode => amount.hashCode ^ currency.hashCode;
}

/// Entity representing salary information
class Salary {
  final double monthlyAmount;
  final String currency;
  final List<ConvertedSalary> converted;

  const Salary({
    required this.monthlyAmount,
    required this.currency,
    required this.converted,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Salary &&
          runtimeType == other.runtimeType &&
          monthlyAmount == other.monthlyAmount &&
          currency == other.currency &&
          _listEquals(converted, other.converted);

  @override
  int get hashCode =>
      monthlyAmount.hashCode ^ currency.hashCode ^ converted.hashCode;
}

/// Entity representing job vacancies
class Vacancies {
  final int male;
  final int female;
  final int total;

  const Vacancies({
    required this.male,
    required this.female,
    required this.total,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vacancies &&
          runtimeType == other.runtimeType &&
          male == other.male &&
          female == other.female &&
          total == other.total;

  @override
  int get hashCode => male.hashCode ^ female.hashCode ^ total.hashCode;
}

/// Entity representing a job position
class Position {
  final String title;
  final Vacancies vacancies;
  final Salary salary;

  const Position({
    required this.title,
    required this.vacancies,
    required this.salary,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          vacancies == other.vacancies &&
          salary == other.salary;

  @override
  int get hashCode => title.hashCode ^ vacancies.hashCode ^ salary.hashCode;
}

/// Entity representing an agency
class Agency {
  final String name;
  final String licenseNumber;

  const Agency({
    required this.name,
    required this.licenseNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Agency &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          licenseNumber == other.licenseNumber;

  @override
  int get hashCode => name.hashCode ^ licenseNumber.hashCode;
}

/// Entity representing an employer
class Employer {
  final String companyName;
  final String country;
  final String city;

  const Employer({
    required this.companyName,
    required this.country,
    required this.city,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employer &&
          runtimeType == other.runtimeType &&
          companyName == other.companyName &&
          country == other.country &&
          city == other.city;

  @override
  int get hashCode =>
      companyName.hashCode ^ country.hashCode ^ city.hashCode;
}

/// Entity representing job search results
class JobsSearchResults {
  final String id;
  final String postingTitle;
  final String country;
  final String city;
  final DateTime postingDateAd;
  final Employer employer;
  final Agency agency;
  final List<Position> positions;

  const JobsSearchResults({
    required this.id,
    required this.postingTitle,
    required this.country,
    required this.city,
    required this.postingDateAd,
    required this.employer,
    required this.agency,
    required this.positions,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobsSearchResults &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          postingTitle == other.postingTitle &&
          country == other.country &&
          city == other.city &&
          postingDateAd == other.postingDateAd &&
          employer == other.employer &&
          agency == other.agency &&
          _listEquals(positions, other.positions);

  @override
  int get hashCode =>
      id.hashCode ^
      postingTitle.hashCode ^
      country.hashCode ^
      city.hashCode ^
      postingDateAd.hashCode ^
      employer.hashCode ^
      agency.hashCode ^
      positions.hashCode;
}

/// Entity representing paginated jobs search results
class PaginatedJobsSearchResults {
  final List<JobsEntity> data;
  final int total;
  final int page;
  final int limit;

  const PaginatedJobsSearchResults({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedJobsSearchResults &&
          runtimeType == other.runtimeType &&
          _listEquals(data, other.data) &&
          total == other.total &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode =>
      data.hashCode ^
      total.hashCode ^
      page.hashCode ^
      limit.hashCode;
}

/// Helper function to compare lists
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}