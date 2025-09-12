import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/candidate/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllCandidateNotifier extends AsyncNotifier<List<CandidateEntity>> {
  @override
  Future<List<CandidateEntity>> build() async {
    final result = await ref.read(getAllCandidateUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetCandidateByIdNotifier extends AsyncNotifier<CandidateEntity?> {
  @override
  Future<CandidateEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getCandidateById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getCandidateByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddCandidateNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addCandidate(CandidateEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addCandidateUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllCandidateProvider);
  }
}

class UpdateCandidateNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateCandidate(CandidateEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateCandidateUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllCandidateProvider);
  }
}

class DeleteCandidateNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteCandidateUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllCandidateProvider);
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

final getAllCandidateProvider = AsyncNotifierProvider<GetAllCandidateNotifier, List<CandidateEntity>>(() {
  return GetAllCandidateNotifier();
});

final getCandidateByIdProvider = AsyncNotifierProvider<GetCandidateByIdNotifier, CandidateEntity?>(() {
  return GetCandidateByIdNotifier();
});

final addCandidateProvider = AsyncNotifierProvider<AddCandidateNotifier, void>(() {
  return AddCandidateNotifier();
});

final updateCandidateProvider = AsyncNotifierProvider<UpdateCandidateNotifier, void>(() {
  return UpdateCandidateNotifier();
});

final deleteCandidateProvider = AsyncNotifierProvider<DeleteCandidateNotifier, void>(() {
  return DeleteCandidateNotifier();
});
