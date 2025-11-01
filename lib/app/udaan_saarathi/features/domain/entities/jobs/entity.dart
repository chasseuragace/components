// abstract class JobsEntity extends BaseEntity {
//   final String id;
//   JobsEntity({
//     // TODO : Jobs : Define params
//     required super.rawJson,
//     required this.id,
//   });
// }

class JobsEntity {
  final String id;
  final String postingTitle;
  final String country;
  final String city;
  final String description;
  final String announcementType;
  final DateTime postingDateAd;
  final String notes;
  final Agency agency;
  final Employer employer;
  final Contract contract;
  final List<Position> positions;
  final List<String> skills;
  final List<String> educationRequirements;
  final ExperienceRequirements experienceRequirements;
  final List<String> canonicalTitles;
  final Expenses expenses;
  final bool interview;
  final String cutoutUrl;
  final int fitnessScore;
  final bool isFeatured;

  JobsEntity({
    required this.id,
    required this.postingTitle,
    required this.country,
    required this.city,
    required this.announcementType,
    required this.postingDateAd,
    required this.notes,
    required this.agency,
    required this.employer,
    required this.contract,
    required this.positions,
    required this.skills,
    required this.educationRequirements,
    required this.experienceRequirements,
    required this.canonicalTitles,
    required this.expenses,
    required this.interview,
    required this.cutoutUrl,
    required this.fitnessScore,
    required this.isFeatured,
    required this.description,
  });
}

class Agency {
  final String name;
  final String licenseNumber;

  Agency({required this.name, required this.licenseNumber});
}

class Employer {
  final String companyName;
  final String country;
  final String city;
  final String companyLogo;

  Employer(
      {required this.companyName,
      required this.country,
      required this.city,
      required this.companyLogo});
}

class Contract {
  final int periodYears;
  final bool renewable;
  final int hoursPerDay;
  final int daysPerWeek;
  final String overtimePolicy;
  final int weeklyOffDays;
  final String food;
  final String accommodation;
  final String transport;
  final int annualLeaveDays;

  Contract({
    required this.periodYears,
    required this.renewable,
    required this.hoursPerDay,
    required this.daysPerWeek,
    required this.overtimePolicy,
    required this.weeklyOffDays,
    required this.food,
    required this.accommodation,
    required this.transport,
    required this.annualLeaveDays,
  });
}

class Position {
  final String title;
  final Vacancies vacancies;
  final Salary salary;
  final Overrides overrides;

  Position({
    required this.title,
    required this.vacancies,
    required this.salary,
    required this.overrides,
  });
}

class Vacancies {
  final int male;
  final int female;
  final int total;

  Vacancies({required this.male, required this.female, required this.total});
}

class Salary {
  final double monthlyAmount;
  final String currency;
  final List<ConvertedSalary> converted;

  Salary(
      {required this.monthlyAmount,
      required this.currency,
      required this.converted});
}

class ConvertedSalary {
  final double amount;
  final String currency;

  ConvertedSalary({required this.amount, required this.currency});
}

class Overrides {
  final int? hoursPerDay;
  final int? daysPerWeek;
  final String? overtimePolicy;
  final int? weeklyOffDays;
  final String? food;
  final String? accommodation;
  final String? transport;

  Overrides({
    this.hoursPerDay,
    this.daysPerWeek,
    this.overtimePolicy,
    this.weeklyOffDays,
    this.food,
    this.accommodation,
    this.transport,
  });
}

class ExperienceRequirements {
  final int minYears;

  ExperienceRequirements({required this.minYears});
}

class Expenses {
  final List<MedicalExpense> medical;
  final List<GenericExpense> insurance;
  final List<TravelExpense> travel;
  final List<GenericExpense> visaPermit;
  final List<TrainingExpense> training;
  final List<WelfareExpense> welfareService;

  Expenses({
    required this.medical,
    required this.insurance,
    required this.travel,
    required this.visaPermit,
    required this.training,
    required this.welfareService,
  });
}

class MedicalExpense {
  final ExpenseDetail domestic;
  final ExpenseDetail foreign;

  MedicalExpense({required this.domestic, required this.foreign});
}

class ExpenseDetail {
  final String whoPays;
  final bool isFree;
  final double? amount;
  final String? currency;
  final bool? refundable;

  ExpenseDetail(
      {required this.whoPays,
      required this.isFree,
      this.amount,
      this.currency,
      this.refundable});
}

class GenericExpense {
  final String whoPays;
  final bool isFree;

  GenericExpense({required this.whoPays, required this.isFree});
}

class TravelExpense {
  final String whoProvides;
  final String ticketType;
  final bool isFree;
  final double? amount;
  final String? currency;

  TravelExpense(
      {required this.whoProvides,
      required this.ticketType,
      required this.isFree,
      this.amount,
      this.currency});
}

class TrainingExpense {
  final String whoPays;
  final bool isFree;
  final double amount;
  final String currency;
  final int durationDays;

  TrainingExpense(
      {required this.whoPays,
      required this.isFree,
      required this.amount,
      required this.currency,
      required this.durationDays});
}

class WelfareExpense {
  final String welfareWhoPays;
  final bool welfareIsFree;
  final double welfareAmount;
  final String welfareCurrency;

  WelfareExpense(
      {required this.welfareWhoPays,
      required this.welfareIsFree,
      required this.welfareAmount,
      required this.welfareCurrency});
}
