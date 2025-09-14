import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Countries/entity.dart';

import '../../../../core/usecases/usecase.dart';
import './di.dart';

class GetAllCountriesNotifier extends AsyncNotifier<List<CountriesEntity>> {
  @override
  Future<List<CountriesEntity>> build() async {
    final result = await ref.read(getAllCountriesUseCaseProvider)(NoParm());
    return result.fold(
      (failure) => throw _mapFailureToException(failure),
      (items) => items,
    );
  }
}

class GetCountriesByIdNotifier extends AsyncNotifier<CountriesEntity?> {
  @override
  Future<CountriesEntity?> build() async {
    return null; // Initially null
  }

  Future<void> getCountriesById(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getCountriesByIdUseCaseProvider)(id);
    state =  result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (item) => AsyncValue.data(null),
    );
  }
}

class AddCountriesNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addCountries(CountriesEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addCountriesUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllCountriesProvider);
  }
}

class UpdateCountriesNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateCountries(CountriesEntity item) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateCountriesUseCaseProvider)(item);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
   );
    ref.invalidate(getAllCountriesProvider);
  }
}

class DeleteCountriesNotifier extends AsyncNotifier {
  @override
  build()  {

  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteCountriesUseCaseProvider)(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure,StackTrace.current),
      (_) => AsyncValue.data(null),
  );
    ref.invalidate(getAllCountriesProvider);
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

final getAllCountriesProvider = AsyncNotifierProvider<GetAllCountriesNotifier, List<CountriesEntity>>(() {
  return GetAllCountriesNotifier();
});

final getCountriesByIdProvider = AsyncNotifierProvider<GetCountriesByIdNotifier, CountriesEntity?>(() {
  return GetCountriesByIdNotifier();
});

final addCountriesProvider = AsyncNotifierProvider<AddCountriesNotifier, void>(() {
  return AddCountriesNotifier();
});

final updateCountriesProvider = AsyncNotifierProvider<UpdateCountriesNotifier, void>(() {
  return UpdateCountriesNotifier();
});

final deleteCountriesProvider = AsyncNotifierProvider<DeleteCountriesNotifier, void>(() {
  return DeleteCountriesNotifier();
});
