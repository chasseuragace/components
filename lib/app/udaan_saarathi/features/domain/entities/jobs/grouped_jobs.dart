// Domain entities for grouped jobs response

class GroupedJobsEntity {
  final List<JobGroupEntity> groups;

  GroupedJobsEntity({required this.groups});
}

class JobGroupEntity {
  final String title;
  final List<GroupJobEntity> jobs;

  JobGroupEntity({required this.title, required this.jobs});
}

class GroupJobEntity {
  final String id;
  final String postingTitle;
  final String country;
  final String? city;
  final List<String> primaryTitles;
  final SalarySummaryEntity salary;
  final AgencyEntity agency;
  final EmployerEntity employer;
  final DateTime? postingDateAd;
  final String? cutoutUrl;
  final int fitnessScore;

  GroupJobEntity({
    required this.id,
    required this.postingTitle,
    required this.country,
    this.city,
    required this.primaryTitles,
    required this.salary,
    required this.agency,
    required this.employer,
    this.postingDateAd,
    this.cutoutUrl,
    required this.fitnessScore,
  });
}

class SalarySummaryEntity {
  final double? monthlyMin;
  final double? monthlyMax;
  final String? currency;
  final List<ConvertedAmountEntity> converted;

  SalarySummaryEntity({
    this.monthlyMin,
    this.monthlyMax,
    this.currency,
    required this.converted,
  });
}

class ConvertedAmountEntity {
  final double amount;
  final String currency;

  ConvertedAmountEntity({
    required this.amount,
    required this.currency,
  });
}

class AgencyEntity {
  final String? name;
  final String? licenseNumber;

  AgencyEntity({this.name, this.licenseNumber});
}

class EmployerEntity {
  final String? companyName;
  final String? country;
  final String? city;

  EmployerEntity({this.companyName, this.country, this.city});
}
