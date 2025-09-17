import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

import '../../../data/datasources/profile/local_data_source.dart';
import '../../../data/datasources/profile/remote_data_source.dart';
import '../../../data/repositories/profile/repository_impl_fake.dart';
import '../../../domain/usecases/profile/add.dart';
import '../../../domain/usecases/profile/delete.dart';
import '../../../domain/usecases/profile/get_all.dart';
import '../../../domain/usecases/profile/get_by_id.dart';
import '../../../domain/usecases/profile/update.dart';

final getAllProfileUseCaseProvider = Provider<GetAllProfileUseCase>((ref) {
  return GetAllProfileUseCase(ref.watch(rProfileRepositoryProvider));
});

final getProfileByIdUseCaseProvider = Provider<GetProfileByIdUseCase>((ref) {
  return GetProfileByIdUseCase(ref.watch(rProfileRepositoryProvider));
});

final addProfileUseCaseProvider = Provider<AddProfileUseCase>((ref) {
  return AddProfileUseCase(ref.watch(rProfileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(rProfileRepositoryProvider));
});

final deleteProfileUseCaseProvider = Provider<DeleteProfileUseCase>((ref) {
  return DeleteProfileUseCase(ref.watch(rProfileRepositoryProvider));
});

final rProfileRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataProfileSourceProvider);
  final remote = ref.read(remoteDataProfileSourceProvider);
  final storage = ref.read(tokenStorageProvider);
  return ProfileRepositoryFake(
      localDataSource: local, remoteDataSource: remote, storage: storage);
});

final localDataProfileSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSourceImpl();
});

final remoteDataProfileSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl();
});
