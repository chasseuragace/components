import '../../models/job_title/model.dart';

/// Unified data source for all option lists used in preferences
/// This centralizes all hardcoded option data and provides a consistent interface
abstract class OptionsDataSource {
  List<String> getGulfCountries();
  List<String> getIndustries();
  List<String> getWorkLocations();
  List<String> getWorkCulture();
  List<String> getAgencies();
  List<String> getCompanySizes();
  List<String> getShiftPreferences();
  List<String> getExperienceLevels();
  List<String> getContractDurations();
  List<String> getWorkBenefits();
  List<JobTitle> getAvailableJobTitles();
}

/// Implementation of options data source with hardcoded data
/// In the future, this could be replaced with API calls or database queries
class OptionsDataSourceImpl implements OptionsDataSource {
  @override
  List<String> getGulfCountries() {
    return [
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
  }

  @override
  List<String> getIndustries() {
    return [
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
  }

  @override
  List<String> getWorkLocations() {
    return [
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
  }

  @override
  List<String> getWorkCulture() {
    return [
      'International Team',
      'Local Team',
      'Mixed Culture',
      'English Speaking',
      'Arabic Speaking',
      'Flexible Environment',
      'Formal Environment',
      'Family-Friendly',
    ];
  }

  @override
  List<String> getAgencies() {
    return [
      'Government Approved Agency',
      'Private Recruitment Agency',
      'Direct Company Hiring',
      'Online Job Portal',
      'Reference/Network',
      'Walk-in Interview',
    ];
  }

  @override
  List<String> getCompanySizes() {
    return [
      'Small (1-50 employees)',
      'Medium (51-200 employees)',
      'Large (201-1000 employees)',
      'Very Large (1000+ employees)',
    ];
  }

  @override
  List<String> getShiftPreferences() {
    return [
      'Day Shift (6 AM - 6 PM)',
      'Night Shift (6 PM - 6 AM)',
      'Split Shift',
      'Rotating Shifts',
      'Weekend Shifts',
      'Flexible Hours',
    ];
  }

  @override
  List<String> getExperienceLevels() {
    return [
      'Entry Level (0-1 years)',
      'Beginner (1-2 years)',
      'Intermediate (2-5 years)',
      'Experienced (5-10 years)',
      'Expert (10+ years)',
    ];
  }

  @override
  List<String> getContractDurations() {
    return [
      '1 Year',
      '2 Years',
      '3 Years',
      '4 Years',
      '5 Years',
      'Permanent',
      'Project Based',
    ];
  }

  @override
  List<String> getWorkBenefits() {
    return [
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
  }

  @override
  List<JobTitle> getAvailableJobTitles() {
    return [
      JobTitle(
        id: '1',
        title: 'Waiter/Waitress',
        category: 'Hospitality',
        isActive: true,
      ),
      JobTitle(id: "2", title: 'Chef', category: 'Hospitality', isActive: true),
      JobTitle(id: "3", title: 'Cook', category: 'Hospitality', isActive: true),
      JobTitle(
        id: "4",
        title: 'Kitchen Helper',
        category: 'Hospitality',
        isActive: true,
      ),
      JobTitle(id: "5", title: 'Barista', category: 'Hospitality', isActive: true),
      JobTitle(id: "6", title: 'Plumber', category: 'Construction', isActive: true),
      JobTitle(
        id: "7",
        title: 'Electrician',
        category: 'Construction',
        isActive: true,
      ),
      JobTitle(
        id: "8",
        title: 'Construction Worker',
        category: 'Construction',
        isActive: true,
      ),
      JobTitle(id: "9", title: 'Painter', category: 'Construction', isActive: true),
      JobTitle(
        id: "10",
        title: 'Driver',
        category: 'Transportation',
        isActive: true,
      ),
      JobTitle(
        id: "11",
        title: 'Delivery Driver',
        category: 'Transportation',
        isActive: true,
      ),
      JobTitle(
        id: "12",
        title: 'Taxi Driver',
        category: 'Transportation',
        isActive: true,
      ),
      JobTitle(
        id: "13",
        title: 'Gardener',
        category: 'Maintenance',
        isActive: true,
      ),
      JobTitle(id: "14", title: 'Cleaner', category: 'Maintenance', isActive: true),
      JobTitle(
        id: "15",
        title: 'Security Guard',
        category: 'Security',
        isActive: true,
      ),
      JobTitle(
        id: "16",
        title: 'Housekeeping',
        category: 'Hospitality',
        isActive: true,
      ),
      JobTitle(id: "17", title: 'Mechanic', category: 'Automotive', isActive: true),
      JobTitle(id: "18", title: 'Welder', category: 'Construction', isActive: true),
      JobTitle(id: "19", title: 'Salesperson', category: 'Retail', isActive: true),
      JobTitle(
        id: "20",
        title: 'Office Assistant',
        category: 'Administration',
        isActive: true,
      ),
    ];
  }
}