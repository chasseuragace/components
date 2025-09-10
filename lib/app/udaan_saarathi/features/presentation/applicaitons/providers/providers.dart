import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/applicaitons/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllApplicaitonsNotifier extends AsyncNotifier<List<ApplicaitonsEntity>> {
  @override
  Future<List<ApplicaitonsEntity>> build() async {
    final result = await ref.read(getAllApplicaitonsUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetApplicaitonsByIdNotifier extends AsyncNotifier<ApplicaitonsEntity?> {
  @override
  Future<ApplicaitonsEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getApplicaitonsById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getApplicaitonsByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddApplicaitonsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addApplicaitons(ApplicaitonsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addApplicaitonsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllApplicaitonsProvider);
  }
}

class UpdateApplicaitonsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateApplicaitons(ApplicaitonsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateApplicaitonsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllApplicaitonsProvider);
  }
}

class DeleteApplicaitonsNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteApplicaitonsUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllApplicaitonsProvider);
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

final getAllApplicaitonsProvider = AsyncNotifierProvider<GetAllApplicaitonsNotifier, List<ApplicaitonsEntity>>(() {
  return GetAllApplicaitonsNotifier();
});

final getApplicaitonsByIdProvider = AsyncNotifierProvider<GetApplicaitonsByIdNotifier, ApplicaitonsEntity?>(() {
  return GetApplicaitonsByIdNotifier();
});

final addApplicaitonsProvider = AsyncNotifierProvider<AddApplicaitonsNotifier, void>(() {
  return AddApplicaitonsNotifier();
});

final updateApplicaitonsProvider = AsyncNotifierProvider<UpdateApplicaitonsNotifier, void>(() {
  return UpdateApplicaitonsNotifier();
});

final deleteApplicaitonsProvider = AsyncNotifierProvider<DeleteApplicaitonsNotifier, void>(() {
  return DeleteApplicaitonsNotifier();
});
