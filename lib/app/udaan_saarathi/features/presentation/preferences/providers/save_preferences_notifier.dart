import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';

/// State for save preferences operation
enum SavePreferencesStatus {
  idle,
  saving,
  success,
  error,
}

/// State class for save preferences
class SavePreferencesState {
  final SavePreferencesStatus status;
  final String? errorMessage;

  const SavePreferencesState({
    required this.status,
    this.errorMessage,
  });

  SavePreferencesState copyWith({
    SavePreferencesStatus? status,
    String? errorMessage,
  }) {
    return SavePreferencesState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

/// Async notifier for saving preferences
class SavePreferencesNotifier extends AsyncNotifier<SavePreferencesState> {
  @override
  Future<SavePreferencesState> build() async {
    return const SavePreferencesState(status: SavePreferencesStatus.idle);
  }

  /// Save preferences with local storage only (job titles handled by separate API)
  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    state = const AsyncValue.loading();
    
    try {
      // Update state to saving
      state = AsyncValue.data(
        const SavePreferencesState(status: SavePreferencesStatus.saving),
      );

      // Create filter data without job titles
      final filterData = <String, dynamic>{};
      preferences.forEach((key, value) {
        if (key != 'jobTitles') {
          filterData[key] = value;
        }
      });
      
      // Save filter template directly to local storage
      await _saveFilterTemplate(filterData);
      
      // Update state to success
      state = AsyncValue.data(
        const SavePreferencesState(status: SavePreferencesStatus.success),
      );
      
    } catch (error, stackTrace) {
      // Update state to error
      state = AsyncValue.data(
        SavePreferencesState(
          status: SavePreferencesStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Save filter template to local storage (for getFilter to load)
  Future<void> _saveFilterTemplate(Map<String, dynamic> filterData) async {
    final localStorage = ref.read(localStorageProvider);
    
    // Save filter data that matches what getFilter() expects
    final filterJson = json.encode(filterData);
    await localStorage.setString('filter_data', filterJson);
    
    print('Saved filter template to local storage');
  }

  /// Reset the state back to idle
  void reset() {
    state = AsyncValue.data(
      const SavePreferencesState(status: SavePreferencesStatus.idle),
    );
  }
}

/// Provider for save preferences notifier
final savePreferencesNotifierProvider = 
    AsyncNotifierProvider<SavePreferencesNotifier, SavePreferencesState>(
  () => SavePreferencesNotifier(),
);