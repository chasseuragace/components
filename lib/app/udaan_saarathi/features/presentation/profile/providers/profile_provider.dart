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

  Future<void> addProfileBlob(List<Map<String, dynamic>> skills) async {
    state = const AsyncValue.loading();

    try {
      state = AsyncValue.data(
        const ProfileState(
          status: ResponseStates.loading,
        ),
      );
      // await Future.delayed(const Duration(seconds: 5));
      final result = await addProfileUseCase(ProfileEntity(
        skills: skills,
        // priority: priority,
      ));

      result.fold(
        (failure) => throw Exception('Failed to add profile blob'),
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
}
