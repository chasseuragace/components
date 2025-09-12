import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/entities/preferences/entity.dart';
import '../../../domain/repositories/preferences/repository.dart';
import '../../datasources/preferences/local_data_source.dart';
import '../../datasources/preferences/remote_data_source.dart';
import '../../models/preferences/model.dart';

// Fake data for Preferencess
final remoteItems = [
  PreferencesModel(
    rawJson: {},
    id: '1',
    name: 'Admin',
  ),
  PreferencesModel(
    rawJson: {},
    id: '2',
    name: 'User',
  ),
  PreferencesModel(
    rawJson: {},
    id: '3',
    name: 'Guest',
  ),
];
final List<String> gulfCountries = [
  'Qatar',
  'UAE (Dubai)',
  'UAE (Abu Dhabi)',
  'UAE (Sharjah)',
  'Saudi Arabia (Riyadh)',
  'Saudi Arabia (Jeddah)',
  'Saudi Arabia (Dammam)',
  'Kuwait',
  'Bahrain',
  'Oman',
];

final List<String> industries = [
  'Hospitality & Tourism',
  'Construction & Infrastructure',
  'Transportation & Logistics',
  'Healthcare',
  'Retail & Sales',
  'Manufacturing',
  'Oil & Gas',
  'Real Estate',
  'Information Technology',
  'Banking & Finance',
  'Education',
  'Agriculture',
];

final List<String> workLocations = [
  'City Center',
  'Industrial Area',
  'Residential Area',
  'Airport Area',
  'Free Zone',
  'Downtown',
  'Suburbs',
  'Port Area',
  'Tourist Area',
  'Business District',
];

final List<String> workCulture = [
  'International Team',
  'Local Team',
  'Mixed Culture',
  'English Speaking',
  'Arabic Speaking',
  'Flexible Environment',
  'Formal Environment',
  'Family-Friendly',
];

final List<String> agencies = [
  'Government Approved Agency',
  'Private Recruitment Agency',
  'Direct Company Hiring',
  'Online Job Portal',
  'Reference/Network',
  'Walk-in Interview',
];

final List<String> companySizes = [
  'Small (1-50 employees)',
  'Medium (51-200 employees)',
  'Large (201-1000 employees)',
  'Very Large (1000+ employees)',
];

final List<String> shiftPreferences = [
  'Day Shift (6 AM - 6 PM)',
  'Night Shift (6 PM - 6 AM)',
  'Split Shift',
  'Rotating Shifts',
  'Weekend Shifts',
  'Flexible Hours',
];

final List<String> experienceLevels = [
  'Entry Level (0-1 years)',
  'Beginner (1-2 years)',
  'Intermediate (2-5 years)',
  'Experienced (5-10 years)',
  'Expert (10+ years)',
];

final List<String> contractDurations = [
  '1 Year',
  '2 Years',
  '3 Years',
  '4 Years',
  '5 Years',
  'Permanent',
  'Project Based',
];
final availableJobTitles = [
  JobTitle(
    id: 1,
    title: 'Waiter/Waitress',
    category: 'Hospitality',
    isActive: true,
  ),
  JobTitle(id: 2, title: 'Chef', category: 'Hospitality', isActive: true),
  JobTitle(id: 3, title: 'Cook', category: 'Hospitality', isActive: true),
  JobTitle(
    id: 4,
    title: 'Kitchen Helper',
    category: 'Hospitality',
    isActive: true,
  ),
  JobTitle(id: 5, title: 'Barista', category: 'Hospitality', isActive: true),
  JobTitle(id: 6, title: 'Plumber', category: 'Construction', isActive: true),
  JobTitle(
    id: 7,
    title: 'Electrician',
    category: 'Construction',
    isActive: true,
  ),
  JobTitle(
    id: 8,
    title: 'Construction Worker',
    category: 'Construction',
    isActive: true,
  ),
  JobTitle(id: 9, title: 'Painter', category: 'Construction', isActive: true),
  JobTitle(
    id: 10,
    title: 'Driver',
    category: 'Transportation',
    isActive: true,
  ),
  JobTitle(
    id: 11,
    title: 'Delivery Driver',
    category: 'Transportation',
    isActive: true,
  ),
  JobTitle(
    id: 12,
    title: 'Taxi Driver',
    category: 'Transportation',
    isActive: true,
  ),
  JobTitle(
    id: 13,
    title: 'Gardener',
    category: 'Maintenance',
    isActive: true,
  ),
  JobTitle(id: 14, title: 'Cleaner', category: 'Maintenance', isActive: true),
  JobTitle(
    id: 15,
    title: 'Security Guard',
    category: 'Security',
    isActive: true,
  ),
  JobTitle(
    id: 16,
    title: 'Housekeeping',
    category: 'Hospitality',
    isActive: true,
  ),
  JobTitle(id: 17, title: 'Mechanic', category: 'Automotive', isActive: true),
  JobTitle(id: 18, title: 'Welder', category: 'Construction', isActive: true),
  JobTitle(id: 19, title: 'Salesperson', category: 'Retail', isActive: true),
  JobTitle(
    id: 20,
    title: 'Office Assistant',
    category: 'Administration',
    isActive: true,
  ),
];
final List<String> workBenefits = [
  'Health Insurance',
  'Paid Annual Leave',
  'Accommodation Provided',
  'Transportation Allowance',
  'Food Allowance',
  'Overtime Pay',
  'End of Service Gratuity',
  'Flight Ticket (Annual)',
  'Family Visa',
  'Training & Development',
  'Performance Bonus',
  'Mobile Allowance',
];

class PreferencesRepositoryFake implements PreferencesRepository {
  final PreferencesLocalDataSource localDataSource;
  final PreferencesRemoteDataSource remoteDataSource;

  PreferencesRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<PreferencesEntity>>> getAllItems() async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PreferencesEntity?>> getItemById(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final remoteItem = remoteItems.firstWhere((item) => item.id == id,
          orElse: () => throw "Not found");
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(PreferencesEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(PreferencesEntity entity) async {
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
}
