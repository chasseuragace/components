import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/options/options_data_source.dart';
import '../../../data/models/job_title/model.dart';
import '../../common/models/option.dart';

/// Provider for the options data source
final optionsDataSourceProvider = Provider<OptionsDataSource>((ref) {
  return OptionsDataSourceImpl();
});

/// Provider for gulf countries options
final gulfCountriesProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getGulfCountries()
      .map((country) => Option(label: country, value: country))
      .toList();
});

/// Provider for industries options
final industriesProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getIndustries()
      .map((industry) => Option(label: industry, value: industry))
      .toList();
});

/// Provider for work locations options
final workLocationsProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getWorkLocations()
      .map((location) => Option(label: location, value: location))
      .toList();
});

/// Provider for work culture options
final workCultureProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getWorkCulture()
      .map((culture) => Option(label: culture, value: culture))
      .toList();
});

/// Provider for agencies options
final agenciesProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getAgencies()
      .map((agency) => Option(label: agency, value: agency))
      .toList();
});

/// Provider for company sizes options
final companySizesProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getCompanySizes()
      .map((size) => Option(label: size, value: size))
      .toList();
});

/// Provider for shift preferences options
final shiftPreferencesProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getShiftPreferences()
      .map((shift) => Option(label: shift, value: shift))
      .toList();
});

/// Provider for experience levels options
final experienceLevelsProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getExperienceLevels()
      .map((level) => Option(label: level, value: level))
      .toList();
});

/// Provider for contract durations options
final contractDurationsProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getContractDurations()
      .map((duration) => Option(label: duration, value: duration))
      .toList();
});

/// Provider for work benefits options
final workBenefitsProvider = Provider<List<Option>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getWorkBenefits()
      .map((benefit) => Option(label: benefit, value: benefit))
      .toList();
});

/// Provider for available job titles
final availableJobTitlesProvider = Provider<List<JobTitle>>((ref) {
  final dataSource = ref.watch(optionsDataSourceProvider);
  return dataSource.getAvailableJobTitles();
});

/// Unified provider for resolving options by source name
/// This is used by the dynamic configuration system
final optionsBySourceProvider = Provider.family<List<Option>, String>((ref, source) {
  switch (source) {
    case 'gulfCountries':
      return ref.watch(gulfCountriesProvider);
    case 'industries':
      return ref.watch(industriesProvider);
    case 'workLocations':
      return ref.watch(workLocationsProvider);
    case 'workCulture':
      return ref.watch(workCultureProvider);
    case 'agencies':
      return ref.watch(agenciesProvider);
    case 'companySizes':
      return ref.watch(companySizesProvider);
    case 'shiftPreferences':
      return ref.watch(shiftPreferencesProvider);
    case 'experienceLevels':
      return ref.watch(experienceLevelsProvider);
    case 'contractDurations':
      return ref.watch(contractDurationsProvider);
    case 'workBenefits':
      return ref.watch(workBenefitsProvider);
    default:
      return const [];
  }
});