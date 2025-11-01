import '../../../data/datasources/Settings/local_data_source.dart';
import '../../../data/datasources/Settings/remote_data_source.dart';
import '../../../data/repositories/Settings/repository_impl.dart';
import '../../../data/repositories/Settings/repository_impl_fake.dart';
import '../../../domain/usecases/Settings/get_all.dart';
import '../../../domain/usecases/Settings/get_by_id.dart';
import '../../../domain/usecases/Settings/add.dart';
import '../../../domain/usecases/Settings/update.dart';
import '../../../domain/usecases/Settings/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllSettingsUseCaseProvider = Provider<GetAllSettingsUseCase>((ref) {
  return GetAllSettingsUseCase(ref.watch(rSettingsRepositoryProvider));
});

final getSettingsByIdUseCaseProvider = Provider<GetSettingsByIdUseCase>((ref) {
  return GetSettingsByIdUseCase(ref.watch(rSettingsRepositoryProvider));
});

final addSettingsUseCaseProvider = Provider<AddSettingsUseCase>((ref) {
  return AddSettingsUseCase(ref.watch(rSettingsRepositoryProvider));
});

final updateSettingsUseCaseProvider = Provider<UpdateSettingsUseCase>((ref) {
  return UpdateSettingsUseCase(ref.watch(rSettingsRepositoryProvider));
});

final deleteSettingsUseCaseProvider = Provider<DeleteSettingsUseCase>((ref) {
  return DeleteSettingsUseCase(ref.watch(rSettingsRepositoryProvider));
});

final rSettingsRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataSettingsSourceProvider);
  final remote = ref.read(remoteDataSettingsSourceProvider);
  return SettingsRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataSettingsSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl();
});

final remoteDataSettingsSourceProvider = Provider<SettingsRemoteDataSource>((ref) {
  return SettingsRemoteDataSourceImpl();
});
