import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/preferences/job_title_preferences_repository.dart';
import '../../../data/repositories/auth/token_storage.dart';

/// Provider for JobTitlePreferencesRepository
final jobTitlePreferencesRepositoryProvider = Provider<JobTitlePreferencesRepository>((ref) {
  return JobTitlePreferencesRepositoryImpl(
    storage: ref.read(tokenStorageProvider),
  );
});

/// State for job title preference operations
enum JobTitlePreferenceStatus {
  idle,
  loading,
  success,
  error,
}

class JobTitlePreferenceState {
  final JobTitlePreferenceStatus status;
  final String? errorMessage;
  final String? lastOperation; // 'add', 'remove', 'reorder'

  const JobTitlePreferenceState({
    required this.status,
    this.errorMessage,
    this.lastOperation,
  });

  JobTitlePreferenceState copyWith({
    JobTitlePreferenceStatus? status,
    String? errorMessage,
    String? lastOperation,
  }) {
    return JobTitlePreferenceState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      lastOperation: lastOperation ?? this.lastOperation,
    );
  }
}

/// Notifier for managing job title preferences
class JobTitlePreferencesNotifier extends AsyncNotifier<JobTitlePreferenceState> {
  @override
  Future<JobTitlePreferenceState> build() async {
    return const JobTitlePreferenceState(status: JobTitlePreferenceStatus.idle);
  }

  /// Add a job title preference with priority
  Future<void> addJobTitlePreference(String jobTitleId, int priority) async {
    state = const AsyncValue.loading();
    
    try {
      state = AsyncValue.data(
        const JobTitlePreferenceState(
          status: JobTitlePreferenceStatus.loading,
          lastOperation: 'add',
        ),
      );

      final repository = ref.read(jobTitlePreferencesRepositoryProvider);
      final result = await repository.addJobTitlePreference(jobTitleId, priority);
      
      result.fold(
        (failure) => throw Exception('Failed to add job title preference'),
        (success) {
          state = AsyncValue.data(
            const JobTitlePreferenceState(
              status: JobTitlePreferenceStatus.success,
              lastOperation: 'add',
            ),
          );
        },
      );
    } catch (error) {
      state = AsyncValue.data(
        JobTitlePreferenceState(
          status: JobTitlePreferenceStatus.error,
          errorMessage: error.toString(),
          lastOperation: 'add',
        ),
      );
    }
  }

  /// Remove a job title preference by title
  Future<void> removeJobTitlePreference(String title) async {
    state = const AsyncValue.loading();
    
    try {
      state = AsyncValue.data(
        const JobTitlePreferenceState(
          status: JobTitlePreferenceStatus.loading,
          lastOperation: 'remove',
        ),
      );

      final repository = ref.read(jobTitlePreferencesRepositoryProvider);
      final result = await repository.removeJobTitlePreference(title);
      
      result.fold(
        (failure) => throw Exception('Failed to remove job title preference'),
        (success) {
          state = AsyncValue.data(
            const JobTitlePreferenceState(
              status: JobTitlePreferenceStatus.success,
              lastOperation: 'remove',
            ),
          );
        },
      );
    } catch (error) {
      state = AsyncValue.data(
        JobTitlePreferenceState(
          status: JobTitlePreferenceStatus.error,
          errorMessage: error.toString(),
          lastOperation: 'remove',
        ),
      );
    }
  }

  /// Reorder job title preferences
  Future<void> reorderJobTitlePreferences(List<String> orderedIds) async {
    state = const AsyncValue.loading();
    
    try {
      state = AsyncValue.data(
        const JobTitlePreferenceState(
          status: JobTitlePreferenceStatus.loading,
          lastOperation: 'reorder',
        ),
      );

      final repository = ref.read(jobTitlePreferencesRepositoryProvider);
      final result = await repository.reorderJobTitlePreferences(orderedIds);
      
      result.fold(
        (failure) => throw Exception('Failed to reorder job title preferences'),
        (success) {
          state = AsyncValue.data(
            const JobTitlePreferenceState(
              status: JobTitlePreferenceStatus.success,
              lastOperation: 'reorder',
            ),
          );
        },
      );
    } catch (error) {
      state = AsyncValue.data(
        JobTitlePreferenceState(
          status: JobTitlePreferenceStatus.error,
          errorMessage: error.toString(),
          lastOperation: 'reorder',
        ),
      );
    }
  }

  /// Reset the state back to idle
  void reset() {
    state = AsyncValue.data(
      const JobTitlePreferenceState(status: JobTitlePreferenceStatus.idle),
    );
  }
}

/// Provider for job title preferences notifier
final jobTitlePreferencesNotifierProvider = 
    AsyncNotifierProvider<JobTitlePreferencesNotifier, JobTitlePreferenceState>(
  () => JobTitlePreferencesNotifier(),
);