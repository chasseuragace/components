import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/preferences/entity.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../domain/repositories/preferences/repository.dart';
import '../../../data/repositories/preferences/repository_impl_fake.dart';
import '../../../data/datasources/preferences/local_data_source.dart';
import '../../../data/datasources/preferences/remote_data_source.dart';
import '../../../data/repositories/auth/token_storage.dart';

// Provider for the preferences repository
final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final localStorage = ref.watch(localStorageProvider);
  return PreferencesRepositoryFake(
    localDataSource: PreferencesLocalDataSourceImpl(localStorage),
    remoteDataSource: PreferencesRemoteDataSourceImpl(),
    storage: tokenStorage,
  );
});

/// Provider for user preferences data (actual user selections)
/// This loads ALL user's saved preferences from server/storage
final userPreferencesProvider = FutureProvider<List<PreferencesEntity>>((ref) async {
  final repository = ref.watch(preferencesRepositoryProvider);
  final result = await repository.getAllItems();
  
  return result.fold(
    (failure) => throw Exception('Failed to load user preferences'),
    (items) => items, // Return all items, not just first
  );
});

/// Provider for filter/template data for pre-filling preferences
/// This loads the user's filter data from the matching engine
final filterDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(preferencesRepositoryProvider);
  final result = await repository.getFilter();
  
  return result.fold(
    (failure) => null, // Return null on failure, UI will use default template
    (filterData) => filterData,
  );
});

/// Provider for steps configuration (UI structure)
/// This defines the flow structure and should always use the default config
/// The server data is only for pre-filling user selections, not changing the UI flow
final stepsConfigProvider = Provider<List<Map<String, dynamic>>>((ref) {
  // Always use default configuration for UI structure
  // Server data is only used for pre-filling user selections
  return _getDefaultStepsConfig();
});

/// Default steps configuration - defines the UI flow structure
/// This is the architectural configuration, not user data
List<Map<String, dynamic>> _getDefaultStepsConfig() {
  return [
    {
      'type': 'builtin',
      'key': 'job_titles',
      'title': 'Job Titles (Priority Order)',
      'subtitle': 'Select and prioritize job titles. Your top choice appears first.',
      'icon': 'work_outline',
      'color': 0xFF3B82F6
    },
    {
      'title': 'Countries & Locations',
      'subtitle': 'Select Gulf countries and preferred locations.',
      'icon': 'public',
      'color': 0xFF059669,
      'sections': [
        {
          'id': 'countries',
          'type': 'multi_select',
          'title': 'Gulf Countries',
          'source': 'gulfCountries',
          'color': 0xFF059669,
          'required': true
        }
      ]
    },
    {
      'title': 'Salary & Work Preferences',
      'subtitle': 'Set your salary expectations and work preferences.',
      'icon': 'attach_money',
      'color': 0xFFDC2626,
      'sections': [
        {
          'id': 'salary',
          'type': 'salary_range',
          'title': 'Expected Monthly Salary (USD)',
          'color': 0xFFDC2626
        }
      ]
    },
    {
      'type': 'builtin',
      'key': 'review',
      'title': 'Review & Confirm',
      'subtitle': 'Review and confirm your job preferences before saving.',
      'icon': 'check_circle_outline',
      'color': 0xFF059669
    }
  ];
}
