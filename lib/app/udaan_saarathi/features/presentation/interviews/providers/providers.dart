import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/interviews/get_all.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/interviews/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';
final interviewPaginaionProvider = StateProvider((ref)=>Pagination());
class GetAllInterviewsNotifier extends AsyncNotifier<InterviewsPaginationEntity> {
  @override
  Future<InterviewsPaginationEntity> build() async {
  final  p =  ref.read(interviewPaginaionProvider);
    final result = await ref.read(getAllInterviewsUseCaseProvider)( p);
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetInterviewsByIdNotifier extends AsyncNotifier<InterviewsEntity?> {
  @override
  Future<InterviewsEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getInterviewsById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getInterviewsByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddInterviewsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addInterviews(InterviewsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addInterviewsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllInterviewsProvider);
  }
}

class UpdateInterviewsNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateInterviews(InterviewsEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateInterviewsUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllInterviewsProvider);
  }
}

class DeleteInterviewsNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteInterviewsUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllInterviewsProvider);
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

final getAllInterviewsProvider = AsyncNotifierProvider<GetAllInterviewsNotifier, InterviewsPaginationEntity>(() {
  return GetAllInterviewsNotifier();
});

final getInterviewsByIdProvider = AsyncNotifierProvider<GetInterviewsByIdNotifier, InterviewsEntity?>(() {
  return GetInterviewsByIdNotifier();
});

final addInterviewsProvider = AsyncNotifierProvider<AddInterviewsNotifier, void>(() {
  return AddInterviewsNotifier();
});

final updateInterviewsProvider = AsyncNotifierProvider<UpdateInterviewsNotifier, void>(() {
  return UpdateInterviewsNotifier();
});

final deleteInterviewsProvider = AsyncNotifierProvider<DeleteInterviewsNotifier, void>(() {
  return DeleteInterviewsNotifier();
});
