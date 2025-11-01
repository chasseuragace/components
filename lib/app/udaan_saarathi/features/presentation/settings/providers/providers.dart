import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Settings/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllSettingsNotifier extends AsyncNotifier<List<SettingsEntity>> {
  @override
  Future<List<SettingsEntity>> build() async {
    final result = await ref.read(getAllSettingsUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetSettingsByIdNotifier extends AsyncNotifier<SettingsEntity?> {
  @override
  Future<SettingsEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getSettingsById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getSettingsByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddSettingsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addSettings(SettingsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addSettingsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllSettingsProvider);
  }
}

class UpdateSettingsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateSettings(SettingsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateSettingsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllSettingsProvider);
  }
}

class DeleteSettingsNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteSettingsUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllSettingsProvider);
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

final getAllSettingsProvider = AsyncNotifierProvider<GetAllSettingsNotifier, List<SettingsEntity>>(() {
  return GetAllSettingsNotifier();
});

final getSettingsByIdProvider = AsyncNotifierProvider<GetSettingsByIdNotifier, SettingsEntity?>(() {
  return GetSettingsByIdNotifier();
});

final addSettingsProvider = AsyncNotifierProvider<AddSettingsNotifier, void>(() {
  return AddSettingsNotifier();
});

final updateSettingsProvider = AsyncNotifierProvider<UpdateSettingsNotifier, void>(() {
  return UpdateSettingsNotifier();
});

final deleteSettingsProvider = AsyncNotifierProvider<DeleteSettingsNotifier, void>(() {
  return DeleteSettingsNotifier();
});
