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
      id: (json['id'] as String?) ?? '',
      postingTitle: (json['posting_title'] as String?) ?? '',
      country: (json['country'] as String?) ?? '',
      city: (json['city'] as String?) ?? '',
      announcementType: json['announcement_type'] ?? '',
      postingDateAd: (() {
        final s = json['posting_date_ad'] as String?;
        if (s == null || s.isEmpty) return DateTime.now();
        return DateTime.tryParse(s) ?? DateTime.now();
      })(),
      notes: (json['notes'] as String?) ?? '',
      agency: AgencyModel.fromJson(
          (json['agency'] as Map<String, dynamic>?) ?? <String, dynamic>{}),
      employer: EmployerModel.fromJson(
          (json['employer'] as Map<String, dynamic>?) ?? <String, dynamic>{}),
      contract: (() {
        final c = json['contract'] as Map<String, dynamic>?;
        if (c != null) return ContractModel.fromJson(c);
        return ContractModel(
          periodYears: 0,
          renewable: false,
          hoursPerDay: 0,
          daysPerWeek: 0,
          overtimePolicy: '',
          weeklyOffDays: 0,
          food: '',
          accommodation: '',
          transport: '',
          annualLeaveDays: 0,
        );
      })(),
      positions: ((json['positions'] as List<dynamic>?) ?? const <dynamic>[])
          .map((p) => PositionModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      skills: ((json['skills'] as List?)?.map((e) => e.toString()).toList()) ??
          const <String>[],
      educationRequirements: ((json['education_requirements'] as List?)
              ?.map((e) => e.toString())
              .toList()) ??
          const <String>[],
      experienceRequirements: (() {
        final er = json['experience_requirements'] as Map<String, dynamic>?;
        if (er != null) return ExperienceRequirementsModel.fromJson(er);
        return ExperienceRequirementsModel(minYears: 0);
      })(),
      canonicalTitles: ((json['canonical_titles'] as List?)
              ?.map((e) => e.toString())
              .toList()) ??
          const <String>[],
      expenses: (() {
        final ex = json['expenses'] as Map<String, dynamic>?;
        if (ex != null) return ExpensesModel.fromJson(ex);
        return ExpensesModel(
          medical: const [],
          insurance: const [],
          travel: const [],
          visaPermit: const [],
          training: const [],
          welfareService: const [],
        );
      })(),
      interview: (json['interview'] as bool?) ?? false,
      cutoutUrl: (json['cutout_url'] as String?) ?? '',
      fitnessScore: (json['fitness_score'] as int?) ?? 0,
      isFeatured: (json['is_featured'] as bool?) ?? false,
      description: (json['description'] as String?) ?? '',
    );
  }
}

// -------- Agency --------
class AgencyModel extends Agency {
  AgencyModel({required super.name, required super.licenseNumber});

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      name: (json['name'] as String?) ?? '',
      licenseNumber: (json['license_number'] as String?) ?? '',
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
      companyName: (json['company_name'] as String?) ?? '',
      country: (json['country'] as String?) ?? '',
      city: (json['city'] as String?) ?? '',
      companyLogo: (json['company_logo'] as String?) ?? '',
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
      periodYears: (json['period_years'] as int?) ?? 0,
      renewable: (json['renewable'] as bool?) ?? false,
      hoursPerDay: (json['hours_per_day'] as int?) ?? 0,
      daysPerWeek: (json['days_per_week'] as int?) ?? 0,
      overtimePolicy: (json['overtime_policy'] as String?) ?? '',
      weeklyOffDays: (json['weekly_off_days'] as int?) ?? 0,
      food: (json['food'] as String?) ?? '',
      accommodation: (json['accommodation'] as String?) ?? '',
      transport: (json['transport'] as String?) ?? '',
      annualLeaveDays: (json['annual_leave_days'] as int?) ?? 0,
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
      overrides: (() {
        final ov = json['overrides'] as Map<String, dynamic>?;
        if (ov != null) return OverridesModel.fromJson(ov);
        return OverridesModel();
      })(),
    );
  }
}

// -------- Vacancies --------
class VacanciesModel extends Vacancies {
  VacanciesModel(
      {required super.male, required super.female, required super.total});

  factory VacanciesModel.fromJson(Map<String, dynamic> json) {
    return VacanciesModel(
      male: (json['male'] as int?) ?? 0,
      female: (json['female'] as int?) ?? 0,
      total: (json['total'] as int?) ?? 0,
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
      monthlyAmount: ((json['monthly_amount'] as num?)?.toDouble()) ?? 0.0,
      currency: (json['currency'] as String?) ?? '',
      converted: ((json['converted'] as List?) ?? const [])
          .map((c) => ConvertedSalaryModel.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

// -------- Converted Salary --------
class ConvertedSalaryModel extends ConvertedSalary {
  ConvertedSalaryModel({required super.amount, required super.currency});

  factory ConvertedSalaryModel.fromJson(Map<String, dynamic> json) {
    return ConvertedSalaryModel(
      amount: ((json['amount'] as num?)?.toDouble()) ?? 0.0,
      currency: (json['currency'] as String?) ?? '',
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
      hoursPerDay: json['hours_per_day'] as int?,
      daysPerWeek: json['days_per_week'] as int?,
      overtimePolicy: json['overtime_policy'] as String?,
      weeklyOffDays: json['weekly_off_days'] as int?,
      food: json['food'] as String?,
      accommodation: json['accommodation'] as String?,
      transport: json['transport'] as String?,
    );
  }
}

// -------- Experience Requirements --------
class ExperienceRequirementsModel extends ExperienceRequirements {
  ExperienceRequirementsModel({required super.minYears});

  factory ExperienceRequirementsModel.fromJson(Map<String, dynamic> json) {
    return ExperienceRequirementsModel(
      minYears: (json['min_years'] as int?) ?? 0,
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
      medical: ((json['medical'] as List?) ?? const [])
          .map((m) => MedicalExpenseModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      insurance: ((json['insurance'] as List?) ?? const [])
          .map((i) => GenericExpenseModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      travel: ((json['travel'] as List?) ?? const [])
          .map((t) => TravelExpenseModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      visaPermit: ((json['visa_permit'] as List?) ?? const [])
          .map((v) => GenericExpenseModel.fromJson(v as Map<String, dynamic>))
          .toList(),
      training: ((json['training'] as List?) ?? const [])
          .map(
              (tr) => TrainingExpenseModel.fromJson(tr as Map<String, dynamic>))
          .toList(),
      welfareService: ((json['welfare_service'] as List?) ?? const [])
          .map((w) => WelfareExpenseModel.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }
}

// -------- Medical Expense --------
class MedicalExpenseModel extends MedicalExpense {
  MedicalExpenseModel({required super.domestic, required super.foreign});

  factory MedicalExpenseModel.fromJson(Map<String, dynamic> json) {
    return MedicalExpenseModel(
      domestic: (() {
        final d = json['domestic'] as Map<String, dynamic>?;
        return d != null
            ? ExpenseDetailModel.fromJson(d)
            : ExpenseDetailModel(whoPays: '', isFree: false);
      })(),
      foreign: (() {
        final f = json['foreign'] as Map<String, dynamic>?;
        return f != null
            ? ExpenseDetailModel.fromJson(f)
            : ExpenseDetailModel(whoPays: '', isFree: false);
      })(),
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
      whoPays: (json['who_pays'] as String?) ?? '',
      isFree: (json['is_free'] as bool?) ?? false,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: (json['currency'] as String?),
      refundable: json['refundable'] as bool?,
    );
  }
}

// -------- Generic Expense --------
class GenericExpenseModel extends GenericExpense {
  GenericExpenseModel({required super.whoPays, required super.isFree});

  factory GenericExpenseModel.fromJson(Map<String, dynamic> json) {
    return GenericExpenseModel(
      whoPays: (json['who_pays'] as String?) ?? '',
      isFree: (json['is_free'] as bool?) ?? false,
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
      whoProvides: (json['who_provides'] as String?) ?? '',
      ticketType: (json['ticket_type'] as String?) ?? '',
      isFree: (json['is_free'] as bool?) ?? false,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: (json['currency'] as String?),
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
      whoPays: (json['who_pays'] as String?) ?? '',
      isFree: (json['is_free'] as bool?) ?? false,
      amount: ((json['amount'] as num?)?.toDouble()) ?? 0.0,
      currency: (json['currency'] as String?) ?? '',
      durationDays: (json['duration_days'] as int?) ?? 0,
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
      welfareWhoPays: (json['welfare_who_pays'] as String?) ?? '',
      welfareIsFree: (json['welfare_is_free'] as bool?) ?? false,
      welfareAmount: ((json['welfare_amount'] as num?)?.toDouble()) ?? 0.0,
      welfareCurrency: (json['welfare_currency'] as String?) ?? '',
    );
  }
}
