import '../../../../core/storage/local_storage.dart';
import '../../../data/datasources/preferences/local_data_source.dart';
import '../../../data/datasources/preferences/remote_data_source.dart';
import '../../../data/repositories/preferences/repository_impl_fake.dart';
import '../../../domain/usecases/preferences/get_all.dart';
import '../../../domain/usecases/preferences/get_by_id.dart';
import '../../../domain/usecases/preferences/add.dart';
import '../../../domain/usecases/preferences/update.dart';
import '../../../domain/usecases/preferences/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth/token_storage.dart';

final getAllPreferencesUseCaseProvider = Provider<GetAllPreferencesUseCase>((ref) {
  return GetAllPreferencesUseCase(ref.watch(rPreferencesRepositoryProvider));
});

final getPreferencesByIdUseCaseProvider = Provider<GetPreferencesByIdUseCase>((ref) {
  return GetPreferencesByIdUseCase(ref.watch(rPreferencesRepositoryProvider));
});

final addPreferencesUseCaseProvider = Provider<AddPreferencesUseCase>((ref) {
  return AddPreferencesUseCase(ref.watch(rPreferencesRepositoryProvider));
});

final updatePreferencesUseCaseProvider = Provider<UpdatePreferencesUseCase>((ref) {
  return UpdatePreferencesUseCase(ref.watch(rPreferencesRepositoryProvider));
});

final deletePreferencesUseCaseProvider = Provider<DeletePreferencesUseCase>((ref) {
  return DeletePreferencesUseCase(ref.watch(rPreferencesRepositoryProvider));
});

final rPreferencesRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataPreferencesSourceProvider);
  final remote = ref.read(remoteDataPreferencesSourceProvider);
  final storage = ref.read(tokenStorageProvider);
  return PreferencesRepositoryFake(
    localDataSource: local,
    remoteDataSource: remote,
    storage: storage,
  );
});

final localDataPreferencesSourceProvider = Provider<PreferencesLocalDataSource>((ref) {
  return PreferencesLocalDataSourceImpl(ref.watch(localStorageProvider));
});

final remoteDataPreferencesSourceProvider = Provider<PreferencesRemoteDataSource>((ref) {
  return PreferencesRemoteDataSourceImpl();
});
