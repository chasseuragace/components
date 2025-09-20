import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/grouped_jobs_model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/mobile_job_model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/jobs/entity.dart';
import '../../../domain/repositories/jobs/repository.dart';
import '../../datasources/jobs/local_data_source.dart';
import '../../datasources/jobs/remote_data_source.dart';

// Fake data for Jobss
// final remoteItems = [
//   JobsModel(
//     rawJson: {},
//     id: '1',
//     name: 'Admin',
//   ),
//   JobsModel(
//     rawJson: {},
//     id: '2',
//     name: 'User',
//   ),
//   JobsModel(
//     rawJson: {},
//     id: '3',
//     name: 'Guest',
//   ),
// ];

final List<JobsEntity> jobPostings = [
  JobsEntity(
    isFeatured: true,
    id: "job_001",
    postingTitle: "UAE-Welder-High",
    country: "UAE",
    city: "Dubai",
    announcementType: "full_ad",
    postingDateAd: DateTime.parse("2025-09-11"),
    notes: "Looking for experienced welders for a large construction project.",
    agency: Agency(
      name: "A",
      licenseNumber: "LIC-AF-1",
    ),
    employer: Employer(
        companyName: "UAE Co 1",
        country: "UAE",
        city: "Dubai",
        companyLogo: ''),
    description: '',
    contract: Contract(
      periodYears: 2,
      renewable: true,
      hoursPerDay: 8,
      daysPerWeek: 6,
      overtimePolicy: "paid",
      weeklyOffDays: 1,
      food: "free",
      accommodation: "free",
      transport: "paid",
      annualLeaveDays: 14,
    ),
    positions: [
      Position(
        title: "Welder",
        vacancies: Vacancies(male: 5, female: 0, total: 5),
        salary: Salary(
          monthlyAmount: 1500,
          currency: "AED",
          converted: [
            ConvertedSalary(amount: 410, currency: "USD"),
            ConvertedSalary(amount: 55000, currency: "NPR"),
          ],
        ),
        overrides: Overrides(),
      ),
    ],
    skills: ["industrial-welding", "arc-welding"],
    educationRequirements: ["technical-diploma"],
    experienceRequirements: ExperienceRequirements(minYears: 2),
    canonicalTitles: ["Welder"],
    expenses: Expenses(
      medical: [
        MedicalExpense(
          domestic: ExpenseDetail(
            whoPays: "worker",
            isFree: false,
            amount: 2000,
            currency: "NPR",
          ),
          foreign: ExpenseDetail(
            whoPays: "company",
            isFree: true,
          ),
        ),
      ],
      insurance: [GenericExpense(whoPays: "company", isFree: true)],
      travel: [
        TravelExpense(
          whoProvides: "company",
          ticketType: "round_trip",
          isFree: false,
          amount: 800,
          currency: "AED",
        ),
      ],
      visaPermit: [GenericExpense(whoPays: "company", isFree: true)],
      training: [
        TrainingExpense(
          whoPays: "worker",
          isFree: false,
          amount: 50,
          currency: "AED",
          durationDays: 2,
        ),
      ],
      welfareService: [
        WelfareExpense(
          welfareWhoPays: "worker",
          welfareIsFree: false,
          welfareAmount: 100,
          welfareCurrency: "AED",
        ),
      ],
    ),
    interview: true,
    cutoutUrl: "/public/LIC-AF-1/job_001/cutout.svg",
    fitnessScore: 67,
  ),
  JobsEntity(
    id: "job_002",
    postingTitle: "Qatar-Electrician",
    country: "Qatar",
    city: "Doha",
    announcementType: "full_ad",
    postingDateAd: DateTime.parse("2025-08-30"),
    notes: "Electricians needed for commercial wiring projects.",
    agency: Agency(name: "Bright Recruitment", licenseNumber: "LIC-QT-22"),
    isFeatured: false,
    employer: Employer(
      companyLogo: '',
      companyName: "Qatar Power Solutions",
      country: "Qatar",
      city: "Doha",
    ),
    contract: Contract(
      periodYears: 3,
      renewable: true,
      hoursPerDay: 9,
      daysPerWeek: 6,
      overtimePolicy: "paid",
      weeklyOffDays: 1,
      food: "free",
      accommodation: "provided",
      transport: "paid",
      annualLeaveDays: 21,
    ),
    description: '',
    positions: [
      Position(
        title: "Electrician",
        vacancies: Vacancies(male: 10, female: 0, total: 10),
        salary: Salary(
          monthlyAmount: 1800,
          currency: "QAR",
          converted: [
            ConvertedSalary(amount: 495, currency: "USD"),
            ConvertedSalary(amount: 67000, currency: "NPR"),
          ],
        ),
        overrides: Overrides(),
      ),
    ],
    skills: ["electrical-systems", "safety-procedures"],
    educationRequirements: ["technical-diploma"],
    experienceRequirements: ExperienceRequirements(minYears: 3),
    canonicalTitles: ["Electrician"],
    expenses: Expenses(
      medical: [],
      insurance: [GenericExpense(whoPays: "company", isFree: true)],
      travel: [
        TravelExpense(
          whoProvides: "company",
          ticketType: "one_way",
          isFree: true,
        ),
      ],
      visaPermit: [GenericExpense(whoPays: "company", isFree: true)],
      training: [],
      welfareService: [],
    ),
    interview: false,
    cutoutUrl: "/public/LIC-QT-22/job_002/cutout.svg",
    fitnessScore: 72,
  ),
  JobsEntity(
    id: "job_003",
    description: '',
    postingTitle: "Saudi-Heavy Driver",
    country: "Saudi Arabia",
    city: "Riyadh",
    announcementType: "short_ad",
    postingDateAd: DateTime.parse("2025-09-05"),
    notes:
        "Urgent requirement for heavy vehicle drivers with valid GCC license.",
    agency: Agency(name: "TransHire", licenseNumber: "LIC-SA-12"),
    isFeatured: true,
    employer: Employer(
      companyLogo: '',
      companyName: "Riyadh Transport Co.",
      country: "Saudi Arabia",
      city: "Riyadh",
    ),
    contract: Contract(
      periodYears: 2,
      renewable: false,
      hoursPerDay: 10,
      daysPerWeek: 6,
      overtimePolicy: "paid",
      weeklyOffDays: 1,
      food: "allowance",
      accommodation: "free",
      transport: "company-provided",
      annualLeaveDays: 30,
    ),
    positions: [
      Position(
        title: "Heavy Driver",
        vacancies: Vacancies(male: 8, female: 0, total: 8),
        salary: Salary(
          monthlyAmount: 2200,
          currency: "SAR",
          converted: [
            ConvertedSalary(amount: 586, currency: "USD"),
            ConvertedSalary(amount: 79000, currency: "NPR"),
          ],
        ),
        overrides: Overrides(),
      ),
    ],
    skills: ["truck-driving", "road-safety"],
    educationRequirements: ["high-school"],
    experienceRequirements: ExperienceRequirements(minYears: 4),
    canonicalTitles: ["Driver"],
    expenses: Expenses(
      medical: [],
      insurance: [GenericExpense(whoPays: "company", isFree: true)],
      travel: [
        TravelExpense(
          whoProvides: "company",
          ticketType: "one_way",
          isFree: true,
        ),
      ],
      visaPermit: [GenericExpense(whoPays: "company", isFree: true)],
      training: [],
      welfareService: [],
    ),
    interview: true,
    cutoutUrl: "/public/LIC-SA-12/job_003/cutout.svg",
    fitnessScore: 75,
  ),
];

class JobsRepositoryFake implements JobsRepository {
  final JobsLocalDataSource localDataSource;
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.storage,
  }) : _api = ApiConfig.client().getCandidatesApi();
  final CandidatesApi _api;
  @override
  Future<Either<Failure, List<JobsEntity>>> getAllItems() async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(jobPostings.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MobileJobEntity>> getItemById(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

    final data=  await  _api.candidateControllerGetJobMobile(id:  (await storage.getCandidateId())!, jobId: id);
     print(data.data!.toJson());
      return right(MobileJobModel.fromJson(data.data!.toJson()));
    } catch (error,s) {
       print(error);
      print(s);
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(JobsEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(JobsEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GroupedJobsEntity>> getGroupedJobs() async {
    try {
      final data = await _api.candidateControllerGetRelevantJobsGrouped(
          id: (await storage.getCandidateId())!);

      return right(GroupedJobsModel.fromJson(data.data!.toJson()));
    } catch (e) {
      return left(ServerFailure());
    }
  }

  final TokenStorage storage;
}
