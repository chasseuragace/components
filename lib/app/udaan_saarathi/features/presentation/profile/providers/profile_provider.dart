import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/profile/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/profile/add.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/di.dart';

final profileProvider = AsyncNotifierProvider<ProfileProvider, ProfileState>(
  ProfileProvider.new,
);

class ProfileState {
  final ResponseStates status;
  final String? errorMessage;
  final String? lastOperation; // 'add', 'remove', 'reorder'
  final String? message;
  const ProfileState({
    required this.status,
    this.errorMessage,
    this.lastOperation,
    this.message,
  });

  ProfileState copyWith({
    ResponseStates? status,
    String? errorMessage,
    String? lastOperation,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      lastOperation: lastOperation ?? this.lastOperation,
      message: message ?? this.message,
    );
  }
}

class ProfileProvider extends AsyncNotifier<ProfileState> {
  late final AddProfileUseCase addProfileUseCase;

  @override
  Future<ProfileState> build() async {
    // Resolve dependencies via ref here
    addProfileUseCase = ref.read(addProfileUseCaseProvider);
    return const ProfileState(status: ResponseStates.initial);
  }

  Future<void> addSkills(List<Map<String, dynamic>> skills) async {
    state = const AsyncValue.loading();

    try {
      state = AsyncValue.data(
        const ProfileState(
          status: ResponseStates.loading,
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
      ));

      result.fold(
        (failure) => throw Exception('Failed to add skills'),
        (success) {
          state = AsyncValue.data(
            const ProfileState(
              status: ResponseStates.success,
              message: 'Skills added successfully',
            ),
          );
        },
      );
    } catch (error) {
      state = AsyncValue.data(
        ProfileState(
          status: ResponseStates.failure,
          errorMessage: error.toString(),
          message: 'Failed to add skills',
        ),
      );
    }
  }

  Future<void> addEducation(List<Map<String, dynamic>> educationList) async {
    state = const AsyncValue.loading();

    try {
      state = AsyncValue.data(
        const ProfileState(
          status: ResponseStates.loading,
        ),
      );
      final result = await addProfileUseCase(ProfileEntity(
        profileBlob: ProfileBlobEntity(
          education: educationList.map((edu) => EducationEntity(
            title: edu['title'] as String?,
            institute: edu['institute'] as String?,
            degree: edu['degree'] as String?,
            document: edu['document'] as String?,
          )).toList(),
        ),
      ));

      result.fold(
        (failure) => throw Exception('Failed to add education'),
        (success) {
          state = AsyncValue.data(
            const ProfileState(
              status: ResponseStates.success,
              message: 'Education added successfully',
            ),
          );
        },
      );
    } catch (error) {
      state = AsyncValue.data(
        ProfileState(
          status: ResponseStates.failure,
          errorMessage: error.toString(),
          message: 'Failed to add education',
        ),
      );
    }
  }

  Future<void> addTrainings(List<Map<String, dynamic>> trainingsList) async {
    state = const AsyncValue.loading();

    try {
      state = AsyncValue.data(
        const ProfileState(
          status: ResponseStates.loading,
        ),
      );
      final result = await addProfileUseCase(ProfileEntity(
        profileBlob: ProfileBlobEntity(
          trainings: trainingsList.map((training) => TrainingEntity(
            title: training['title'] as String?,
            provider: training['provider'] as String?,
            hours: training['hours'] as int?,
            certificate: training['certificate'] as bool?,
          )).toList(),
        ),
      ));

      result.fold(
        (failure) => throw Exception('Failed to add trainings'),
        (success) {
          state = AsyncValue.data(
            const ProfileState(
              status: ResponseStates.success,
              message: 'Trainings added successfully',
            ),
          );
        },
      );
    } catch (error) {
      state = AsyncValue.data(
        ProfileState(
          status: ResponseStates.failure,
          errorMessage: error.toString(),
          message: 'Failed to add trainings',
        ),
      );
    }
  }

  Future<void> addExperience(List<Map<String, dynamic>> experienceList) async {
    state = const AsyncValue.loading();

    try {
      state = AsyncValue.data(
        const ProfileState(
          status: ResponseStates.loading,
        ),
      );
      final result = await addProfileUseCase(ProfileEntity(
        profileBlob: ProfileBlobEntity(
          experience: experienceList.map((exp) => ExperienceEntity(
            title: exp['title'] as String?,
            employer: exp['employer'] as String?,
            startDateAd: exp['start_date_ad'] as String?,
            endDateAd: exp['end_date_ad'] as String?,
            months: exp['months'] as int?,
            description: exp['description'] as String?,
          )).toList(),
        ),
      ));

      result.fold(
        (failure) => throw Exception('Failed to add experience'),
        (success) {
          state = AsyncValue.data(
            const ProfileState(
              status: ResponseStates.success,
              message: 'Experience added successfully',
            ),
          );
        },
      );
    } catch (error) {
      state = AsyncValue.data(
        ProfileState(
          status: ResponseStates.failure,
          errorMessage: error.toString(),
          message: 'Failed to add experience',
        ),
      );
    }
  }

  Future<void> addPersonalInfo(Map<String, dynamic> personalInfo) async {
    state = const AsyncValue.loading();

    try {
      state = AsyncValue.data(
        const ProfileState(
          status: ResponseStates.loading,
        ),
      );
      final result = await addProfileUseCase(ProfileEntity(
        profileBlob: ProfileBlobEntity(
          // Add personal info mapping here
        ),
      ));

      result.fold(
        (failure) => throw Exception('Failed to add personal info'),
        (success) {
          state = AsyncValue.data(
            const ProfileState(
              status: ResponseStates.success,
              message: 'Personal info updated successfully',
            ),
          );
        },
      );
    } catch (error) {
      state = AsyncValue.data(
        ProfileState(
          status: ResponseStates.failure,
          errorMessage: error.toString(),
          message: 'Failed to update personal info',
        ),
      );
    }
  }
}
