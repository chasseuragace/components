import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/profile/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllProfileNotifier extends AsyncNotifier<List<ProfileEntity>> {
  @override
  Future<List<ProfileEntity>> build() async {
    final result = await ref.read(getAllProfileUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetProfileByIdNotifier extends AsyncNotifier<ProfileEntity?> {
  @override
  Future<ProfileEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getProfileById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getProfileByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddProfileNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addProfile(ProfileEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addProfileUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllProfileProvider);
  }
}

class UpdateProfileNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateProfile(ProfileEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateProfileUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllProfileProvider);
  }
}

class DeleteProfileNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteProfileUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllProfileProvider);
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

final getAllProfileProvider = AsyncNotifierProvider<GetAllProfileNotifier, List<ProfileEntity>>(() {
  return GetAllProfileNotifier();
});

final getProfileByIdProvider = AsyncNotifierProvider<GetProfileByIdNotifier, ProfileEntity?>(() {
  return GetProfileByIdNotifier();
});

final addProfileProvider = AsyncNotifierProvider<AddProfileNotifier, void>(() {
  return AddProfileNotifier();
});

final updateProfileProvider = AsyncNotifierProvider<UpdateProfileNotifier, void>(() {
  return UpdateProfileNotifier();
});

final deleteProfileProvider = AsyncNotifierProvider<DeleteProfileNotifier, void>(() {
  return DeleteProfileNotifier();
});
