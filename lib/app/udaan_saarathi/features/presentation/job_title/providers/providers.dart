import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/job_title/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllJobTitleNotifier extends AsyncNotifier<List<JobTitleEntity>> {
  @override
  Future<List<JobTitleEntity>> build() async {
    final result = await ref.read(getAllJobTitleUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetJobTitleByIdNotifier extends AsyncNotifier<JobTitleEntity?> {
  @override
  Future<JobTitleEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getJobTitleById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getJobTitleByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddJobTitleNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addJobTitle(JobTitleEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addJobTitleUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllJobTitleProvider);
  }
}

class UpdateJobTitleNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateJobTitle(JobTitleEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateJobTitleUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllJobTitleProvider);
  }
}

class DeleteJobTitleNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteJobTitleUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllJobTitleProvider);
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

final getAllJobTitleProvider = AsyncNotifierProvider<GetAllJobTitleNotifier, List<JobTitleEntity>>(() {
  return GetAllJobTitleNotifier();
});

final getJobTitleByIdProvider = AsyncNotifierProvider<GetJobTitleByIdNotifier, JobTitleEntity?>(() {
  return GetJobTitleByIdNotifier();
});

final addJobTitleProvider = AsyncNotifierProvider<AddJobTitleNotifier, void>(() {
  return AddJobTitleNotifier();
});

final updateJobTitleProvider = AsyncNotifierProvider<UpdateJobTitleNotifier, void>(() {
  return UpdateJobTitleNotifier();
});

final deleteJobTitleProvider = AsyncNotifierProvider<DeleteJobTitleNotifier, void>(() {
  return DeleteJobTitleNotifier();
});
