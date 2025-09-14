import '../../../data/datasources/countries/local_data_source.dart';
import '../../../data/datasources/countries/remote_data_source.dart';
import '../../../data/repositories/countries/repository_impl.dart';
import '../../../data/repositories/countries/repository_impl_fake.dart';
import '../../../domain/usecases/countries/get_all.dart';
import '../../../domain/usecases/countries/get_by_id.dart';
import '../../../domain/usecases/countries/add.dart';
import '../../../domain/usecases/countries/update.dart';
import '../../../domain/usecases/countries/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllCountriesUseCaseProvider = Provider<GetAllCountriesUseCase>((ref) {
  return GetAllCountriesUseCase(ref.watch(rCountriesRepositoryProvider));
});

final getCountriesByIdUseCaseProvider = Provider<GetCountriesByIdUseCase>((ref) {
  return GetCountriesByIdUseCase(ref.watch(rCountriesRepositoryProvider));
});

final addCountriesUseCaseProvider = Provider<AddCountriesUseCase>((ref) {
  return AddCountriesUseCase(ref.watch(rCountriesRepositoryProvider));
});

final updateCountriesUseCaseProvider = Provider<UpdateCountriesUseCase>((ref) {
  return UpdateCountriesUseCase(ref.watch(rCountriesRepositoryProvider));
});

final deleteCountriesUseCaseProvider = Provider<DeleteCountriesUseCase>((ref) {
  return DeleteCountriesUseCase(ref.watch(rCountriesRepositoryProvider));
});

final rCountriesRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataCountriesSourceProvider);
  final remote = ref.read(remoteDataCountriesSourceProvider);
  return CountriesRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataCountriesSourceProvider = Provider<CountriesLocalDataSource>((ref) {
  return CountriesLocalDataSourceImpl();
});

final remoteDataCountriesSourceProvider = Provider<CountriesRemoteDataSource>((ref) {
  return CountriesRemoteDataSourceImpl();
});
