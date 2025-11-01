import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/profile/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/profile/add.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/job_title_preferences_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/di.dart';

final profileProvider =
    AsyncNotifierProvider<ProfileProvider, JobTitlePreferenceState>(
  ProfileProvider.new,
);

class ProfileProvider extends AsyncNotifier<JobTitlePreferenceState> {
  late final AddProfileUseCase addProfileUseCase;

  @override
  Future<JobTitlePreferenceState> build() async {
    // Resolve dependencies via ref here
    addProfileUseCase = ref.read(addProfileUseCaseProvider);
    return const JobTitlePreferenceState(status: JobTitlePreferenceStatus.idle);
  }

  Future<void> addProfileBlob(List<Map<String, dynamic>> skills) async {
    state = const AsyncValue.loading();

    try {
      state = AsyncValue.data(
        const JobTitlePreferenceState(
          status: JobTitlePreferenceStatus.loading,
        ),
      );
      final result = await addProfileUseCase(ProfileEntity(
        profileBlob: ProfileBlobEntity(
          skills: skills.map((skill) => SkillEntity(
            title: skill['title'] as String?,
            durationMonths: skill['duration_months'] as int?,
            years: skill['years'] as int?,
            documents: (skill['documents'] as List<dynamic>?)?.cast<String>(),
          )).toList(),
        ),
        // priority: priority,
      ));

      result.fold(
        (failure) => throw Exception('Failed to add profile blob'),
        (success) {
          state = AsyncValue.data(
            const JobTitlePreferenceState(
              status: JobTitlePreferenceStatus.success,
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
}
