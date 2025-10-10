import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Agency/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllAgencyNotifier extends AsyncNotifier<List<AgencyEntity>> {
  @override
  Future<List<AgencyEntity>> build() async {
    final result = await ref.read(getAllAgencyUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetAgencyByIdNotifier extends AsyncNotifier<AgencyEntity?> {
  @override
  Future<AgencyEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getAgencyById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getAgencyByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddAgencyNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addAgency(AgencyEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addAgencyUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllAgencyProvider);
  }
}

class UpdateAgencyNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateAgency(AgencyEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateAgencyUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllAgencyProvider);
  }
}

class DeleteAgencyNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteAgencyUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllAgencyProvider);
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

final getAllAgencyProvider = AsyncNotifierProvider<GetAllAgencyNotifier, List<AgencyEntity>>(() {
  return GetAllAgencyNotifier();
});

final getAgencyByIdProvider = AsyncNotifierProvider<GetAgencyByIdNotifier, AgencyEntity?>(() {
  return GetAgencyByIdNotifier();
});

final addAgencyProvider = AsyncNotifierProvider<AddAgencyNotifier, void>(() {
  return AddAgencyNotifier();
});

final updateAgencyProvider = AsyncNotifierProvider<UpdateAgencyNotifier, void>(() {
  return UpdateAgencyNotifier();
});

final deleteAgencyProvider = AsyncNotifierProvider<DeleteAgencyNotifier, void>(() {
  return DeleteAgencyNotifier();
});
