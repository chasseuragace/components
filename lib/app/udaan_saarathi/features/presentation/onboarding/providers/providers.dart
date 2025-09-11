import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Onboarding/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllOnboardingNotifier extends AsyncNotifier<List<OnboardingEntity>> {
  @override
  Future<List<OnboardingEntity>> build() async {
    final result = await ref.read(getAllOnboardingUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetOnboardingByIdNotifier extends AsyncNotifier<OnboardingEntity?> {
  @override
  Future<OnboardingEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getOnboardingById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getOnboardingByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddOnboardingNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addOnboarding(OnboardingEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addOnboardingUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllOnboardingProvider);
  }
}

class UpdateOnboardingNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateOnboarding(OnboardingEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateOnboardingUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllOnboardingProvider);
  }
}

class DeleteOnboardingNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteOnboardingUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllOnboardingProvider);
  }
}

Exception _mapFailureToException(Failure failure) {
  if (failure is ServerFailure) {
    return Exception('Server failure');
  } else if (failure is CacheFailure) {
    return Exception('Cache failure');
  } else {
    return Exception('Unexpected error');
  }
}

final getAllOnboardingProvider = AsyncNotifierProvider<GetAllOnboardingNotifier, List<OnboardingEntity>>(() {
  return GetAllOnboardingNotifier();
});

final getOnboardingByIdProvider = AsyncNotifierProvider<GetOnboardingByIdNotifier, OnboardingEntity?>(() {
  return GetOnboardingByIdNotifier();
});

final addOnboardingProvider = AsyncNotifierProvider<AddOnboardingNotifier, void>(() {
  return AddOnboardingNotifier();
});

final updateOnboardingProvider = AsyncNotifierProvider<UpdateOnboardingNotifier, void>(() {
  return UpdateOnboardingNotifier();
});

final deleteOnboardingProvider = AsyncNotifierProvider<DeleteOnboardingNotifier, void>(() {
  return DeleteOnboardingNotifier();
});
