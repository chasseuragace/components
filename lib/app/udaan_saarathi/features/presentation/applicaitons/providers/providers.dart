import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_details_entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/apply_job_d_t_o_entity.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../domain/entities/applicaitons/entity.dart';
import './di.dart';

class GetAllApplicaitonsNotifier
    extends AsyncNotifier<List<ApplicaitonsEntity>> {
  @override
  Future<List<ApplicaitonsEntity>> build() async {
    final result = await ref.read(getAllApplicaitonsUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items.items,
    );
  }
}

class GetApplicaitonsByIdNotifier extends AsyncNotifier<ApplicationDetailsEntity?> {
  @override
  Future<ApplicationDetailsEntity?> build() async {
    final selectedId = ref.watch(selectedApplicationIdProvider);
    if (selectedId == null) return null;
    
    final result = await ref.read(getApplicaitonsByIdUseCaseProvider)(selectedId);
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (item) => item,
    );
  }
}

// class AddApplicaitonsNotifier extends AsyncNotifier {
//   @override
//   Future<void> build() async {
//     return;
//   }

//   Future<void> addApplicaitons(ApplyJobDTOEntity item) async {
//     state = const AsyncValue.loading();
//     final result = await ref.read(addApplicaitonsUseCaseProvider)(item);
//     state = result.fold(
//       (failure) => AsyncValue.error(failure, StackTrace.current),
//       (_) => AsyncValue.data(null),
//     );
//     ref.invalidate(getAllApplicaitonsProvider);
//   }
// }

class ApplyJobNotifier extends AsyncNotifier {
  @override
  build() {
    return null;
  }

  Future<void> applyJob(ApplyJobDTOEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(applyJobUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllApplicaitonsProvider);
  }
}
class WithdrawJobNotifier extends AsyncNotifier {
  @override
  build() {
    return null;
  }

  Future<void> withdrawJob(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(withdrawJobUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
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
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
    ref.invalidate(getAllApplicaitonsProvider);
  }
}

class DeleteApplicaitonsNotifier extends AsyncNotifier {
  @override
  build() {}

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteApplicaitonsUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
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

final getAllApplicaitonsProvider =
    AsyncNotifierProvider<GetAllApplicaitonsNotifier, List<ApplicaitonsEntity>>(
        () {
  return GetAllApplicaitonsNotifier();
});

final getApplicaitonsByIdProvider =
    AsyncNotifierProvider<GetApplicaitonsByIdNotifier, ApplicationDetailsEntity?>(() {
  return GetApplicaitonsByIdNotifier();
});

// State provider for selected application ID
final selectedApplicationIdProvider = StateProvider<String?>((ref) => null);

// final addApplicaitonsProvider =
//     AsyncNotifierProvider<AddApplicaitonsNotifier, void>(() {
//   return AddApplicaitonsNotifier();
// });

final updateApplicaitonsProvider =
    AsyncNotifierProvider<UpdateApplicaitonsNotifier, void>(() {
  return UpdateApplicaitonsNotifier();
});

final deleteApplicaitonsProvider =
    AsyncNotifierProvider<DeleteApplicaitonsNotifier, void>(() {
  return DeleteApplicaitonsNotifier();
});

// Apply job provider
final applyJobProvider = AsyncNotifierProvider<ApplyJobNotifier, void>(() {
  return ApplyJobNotifier();
});
final withdrawJobProvider = AsyncNotifierProvider<WithdrawJobNotifier, void>(() {
  return WithdrawJobNotifier();
});
