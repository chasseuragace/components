import '../../../domain/entities/jobs/entity.dart';

class JobsModel extends JobsEntity {
  JobsModel(
      {required super.id,
      required super.postingTitle,
      required super.country,
      required super.city,
      required super.announcementType,
      required super.postingDateAd,
      required super.notes,
      required super.agency,
      required super.employer,
      required super.contract,
      required super.positions,
      required super.skills,
      required super.educationRequirements,
      required super.experienceRequirements,
      required super.canonicalTitles,
      required super.expenses,
      required super.interview,
      required super.cutoutUrl,
      required super.fitnessScore,
      required super.isFeatured,
      required super.description});

  factory JobsModel.fromJson(Map<String, dynamic> json) {
    return JobsModel(
      id: json['id'],
      postingTitle: json['posting_title'],
      country: json['country'],
      city: json['city'],
      announcementType: json['announcement_type'],
      postingDateAd: DateTime.parse(json['posting_date_ad']),
      notes: json['notes'],
      agency: AgencyModel.fromJson(json['agency']),
      employer: EmployerModel.fromJson(json['employer']),
      contract: ContractModel.fromJson(json['contract']),
      positions: (json['positions'] as List)
          .map((p) => PositionModel.fromJson(p))
          .toList(),
      skills: List<String>.from(json['skills']),
      educationRequirements: List<String>.from(json['education_requirements']),
      experienceRequirements:
          ExperienceRequirementsModel.fromJson(json['experience_requirements']),
      canonicalTitles: List<String>.from(json['canonical_titles']),
      expenses: ExpensesModel.fromJson(json['expenses']),
      interview: json['interview'],
      cutoutUrl: json['cutout_url'],
      fitnessScore: json['fitness_score'],
      isFeatured: json['is_featured'],
      description: json['description'],
    );
  }
}

// -------- Agency --------
class AgencyModel extends Agency {
  AgencyModel({required super.name, required super.licenseNumber});

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      name: json['name'],
      licenseNumber: json['license_number'],
    );
  }
}

// -------- Employer --------
class EmployerModel extends Employer {
  EmployerModel(
      {required super.companyName,
      required super.country,
      required super.city,
      required super.companyLogo});

  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      companyName: json['company_name'],
      country: json['country'],
      city: json['city'],
      companyLogo: json['company_logo'],
    );
  }
}

// -------- Contract --------
class ContractModel extends Contract {
  ContractModel({
    required super.periodYears,
    required super.renewable,
    required super.hoursPerDay,
    required super.daysPerWeek,
    required super.overtimePolicy,
    required super.weeklyOffDays,
    required super.food,
    required super.accommodation,
    required super.transport,
    required super.annualLeaveDays,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      periodYears: json['period_years'],
      renewable: json['renewable'],
      hoursPerDay: json['hours_per_day'],
      daysPerWeek: json['days_per_week'],
      overtimePolicy: json['overtime_policy'],
      weeklyOffDays: json['weekly_off_days'],
      food: json['food'],
      accommodation: json['accommodation'],
      transport: json['transport'],
      annualLeaveDays: json['annual_leave_days'],
    );
  }
}

// -------- Position --------
class PositionModel extends Position {
  PositionModel({
    required super.title,
    required super.vacancies,
    required super.salary,
    required super.overrides,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      title: json['title'],
      vacancies: VacanciesModel.fromJson(json['vacancies']),
      salary: SalaryModel.fromJson(json['salary']),
      overrides: OverridesModel.fromJson(json['overrides']),
    );
  }
}

// -------- Vacancies --------
class VacanciesModel extends Vacancies {
  VacanciesModel(
      {required super.male, required super.female, required super.total});

  factory VacanciesModel.fromJson(Map<String, dynamic> json) {
    return VacanciesModel(
      male: json['male'],
      female: json['female'],
      total: json['total'],
    );
  }
}

// -------- Salary --------
class SalaryModel extends Salary {
  SalaryModel(
      {required super.monthlyAmount,
      required super.currency,
      required super.converted});

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      monthlyAmount: json['monthly_amount'].toDouble(),
      currency: json['currency'],
      converted: (json['converted'] as List)
          .map((c) => ConvertedSalaryModel.fromJson(c))
          .toList(),
    );
  }
}

// -------- Converted Salary --------
class ConvertedSalaryModel extends ConvertedSalary {
  ConvertedSalaryModel({required super.amount, required super.currency});

  factory ConvertedSalaryModel.fromJson(Map<String, dynamic> json) {
    return ConvertedSalaryModel(
      amount: json['amount'].toDouble(),
      currency: json['currency'],
    );
  }
}

// -------- Overrides --------
class OverridesModel extends Overrides {
  OverridesModel({
    super.hoursPerDay,
    super.daysPerWeek,
    super.overtimePolicy,
    super.weeklyOffDays,
    super.food,
    super.accommodation,
    super.transport,
  });

  factory OverridesModel.fromJson(Map<String, dynamic> json) {
    return OverridesModel(
      hoursPerDay: json['hours_per_day'],
      daysPerWeek: json['days_per_week'],
      overtimePolicy: json['overtime_policy'],
      weeklyOffDays: json['weekly_off_days'],
      food: json['food'],
      accommodation: json['accommodation'],
      transport: json['transport'],
    );
  }
}

// -------- Experience Requirements --------
class ExperienceRequirementsModel extends ExperienceRequirements {
  ExperienceRequirementsModel({required super.minYears});

  factory ExperienceRequirementsModel.fromJson(Map<String, dynamic> json) {
    return ExperienceRequirementsModel(
      minYears: json['min_years'],
    );
  }
}

// -------- Expenses --------
class ExpensesModel extends Expenses {
  ExpensesModel({
    required super.medical,
    required super.insurance,
    required super.travel,
    required super.visaPermit,
    required super.training,
    required super.welfareService,
  });

  factory ExpensesModel.fromJson(Map<String, dynamic> json) {
    return ExpensesModel(
      medical: (json['medical'] as List)
          .map((m) => MedicalExpenseModel.fromJson(m))
          .toList(),
      insurance: (json['insurance'] as List)
          .map((i) => GenericExpenseModel.fromJson(i))
          .toList(),
      travel: (json['travel'] as List)
          .map((t) => TravelExpenseModel.fromJson(t))
          .toList(),
      visaPermit: (json['visa_permit'] as List)
          .map((v) => GenericExpenseModel.fromJson(v))
          .toList(),
      training: (json['training'] as List)
          .map((tr) => TrainingExpenseModel.fromJson(tr))
          .toList(),
      welfareService: (json['welfare_service'] as List)
          .map((w) => WelfareExpenseModel.fromJson(w))
          .toList(),
    );
  }
}

// -------- Medical Expense --------
class MedicalExpenseModel extends MedicalExpense {
  MedicalExpenseModel({required super.domestic, required super.foreign});

  factory MedicalExpenseModel.fromJson(Map<String, dynamic> json) {
    return MedicalExpenseModel(
      domestic: ExpenseDetailModel.fromJson(json['domestic']),
      foreign: ExpenseDetailModel.fromJson(json['foreign']),
    );
  }
}

// -------- Expense Detail --------
class ExpenseDetailModel extends ExpenseDetail {
  ExpenseDetailModel({
    required super.whoPays,
    required super.isFree,
    super.amount,
    super.currency,
    super.refundable,
  });

  factory ExpenseDetailModel.fromJson(Map<String, dynamic> json) {
    return ExpenseDetailModel(
      whoPays: json['who_pays'],
      isFree: json['is_free'],
      amount: json['amount']?.toDouble(),
      currency: json['currency'],
      refundable: json['refundable'],
    );
  }
}

// -------- Generic Expense --------
class GenericExpenseModel extends GenericExpense {
  GenericExpenseModel({required super.whoPays, required super.isFree});

  factory GenericExpenseModel.fromJson(Map<String, dynamic> json) {
    return GenericExpenseModel(
      whoPays: json['who_pays'],
      isFree: json['is_free'],
    );
  }
}

// -------- Travel Expense --------
class TravelExpenseModel extends TravelExpense {
  TravelExpenseModel({
    required super.whoProvides,
    required super.ticketType,
    required super.isFree,
    super.amount,
    super.currency,
  });

  factory TravelExpenseModel.fromJson(Map<String, dynamic> json) {
    return TravelExpenseModel(
      whoProvides: json['who_provides'],
      ticketType: json['ticket_type'],
      isFree: json['is_free'],
      amount: json['amount']?.toDouble(),
      currency: json['currency'],
    );
  }
}

// -------- Training Expense --------
class TrainingExpenseModel extends TrainingExpense {
  TrainingExpenseModel({
    required super.whoPays,
    required super.isFree,
    required super.amount,
    required super.currency,
    required super.durationDays,
  });

  factory TrainingExpenseModel.fromJson(Map<String, dynamic> json) {
    return TrainingExpenseModel(
      whoPays: json['who_pays'],
      isFree: json['is_free'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      durationDays: json['duration_days'],
    );
  }
}

// -------- Welfare Expense --------
class WelfareExpenseModel extends WelfareExpense {
  WelfareExpenseModel({
    required super.welfareWhoPays,
    required super.welfareIsFree,
    required super.welfareAmount,
    required super.welfareCurrency,
  });

  factory WelfareExpenseModel.fromJson(Map<String, dynamic> json) {
    return WelfareExpenseModel(
      welfareWhoPays: json['welfare_who_pays'],
      welfareIsFree: json['welfare_is_free'],
      welfareAmount: json['welfare_amount'].toDouble(),
      welfareCurrency: json['welfare_currency'],
    );
  }
}
