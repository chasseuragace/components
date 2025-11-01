import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/preferences/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllPreferencesNotifier extends AsyncNotifier<List<PreferencesEntity>> {
  @override
  Future<List<PreferencesEntity>> build() async {
    final result = await ref.read(getAllPreferencesUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetPreferencesByIdNotifier extends AsyncNotifier<PreferencesEntity?> {
  @override
  Future<PreferencesEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getPreferencesById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getPreferencesByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddPreferencesNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addPreferences(PreferencesEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addPreferencesUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllPreferencesProvider);
  }
}

class UpdatePreferencesNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updatePreferences(PreferencesEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updatePreferencesUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllPreferencesProvider);
  }
}

class DeletePreferencesNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deletePreferencesUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllPreferencesProvider);
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

final getAllPreferencesProvider = AsyncNotifierProvider<GetAllPreferencesNotifier, List<PreferencesEntity>>(() {
  return GetAllPreferencesNotifier();
});

final getPreferencesByIdProvider = AsyncNotifierProvider<GetPreferencesByIdNotifier, PreferencesEntity?>(() {
  return GetPreferencesByIdNotifier();
});

final addPreferencesProvider = AsyncNotifierProvider<AddPreferencesNotifier, void>(() {
  return AddPreferencesNotifier();
});

final updatePreferencesProvider = AsyncNotifierProvider<UpdatePreferencesNotifier, void>(() {
  return UpdatePreferencesNotifier();
});

final deletePreferencesProvider = AsyncNotifierProvider<DeletePreferencesNotifier, void>(() {
  return DeletePreferencesNotifier();
});
