import '../../../data/datasources/splash/local_data_source.dart';
import '../../../data/datasources/splash/remote_data_source.dart';

import '../../../data/repositories/splash/repository_impl_fake.dart';
import '../../../domain/usecases/splash/get_all.dart';
import '../../../domain/usecases/splash/get_by_id.dart';
import '../../../domain/usecases/splash/add.dart';
import '../../../domain/usecases/splash/update.dart';
import '../../../domain/usecases/splash/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllSplashUseCaseProvider = Provider<GetAllSplashUseCase>((ref) {
  return GetAllSplashUseCase(ref.watch(rSplashRepositoryProvider));
});

final getSplashByIdUseCaseProvider = Provider<GetSplashByIdUseCase>((ref) {
  return GetSplashByIdUseCase(ref.watch(rSplashRepositoryProvider));
});

final addSplashUseCaseProvider = Provider<AddSplashUseCase>((ref) {
  return AddSplashUseCase(ref.watch(rSplashRepositoryProvider));
});

final updateSplashUseCaseProvider = Provider<UpdateSplashUseCase>((ref) {
  return UpdateSplashUseCase(ref.watch(rSplashRepositoryProvider));
});

final deleteSplashUseCaseProvider = Provider<DeleteSplashUseCase>((ref) {
  return DeleteSplashUseCase(ref.watch(rSplashRepositoryProvider));
});

final rSplashRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataSplashSourceProvider);
  final remote = ref.read(remoteDataSplashSourceProvider);
  return SplashRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataSplashSourceProvider = Provider<SplashLocalDataSource>((ref) {
  return SplashLocalDataSourceImpl();
});

final remoteDataSplashSourceProvider = Provider<SplashRemoteDataSource>((ref) {
  return SplashRemoteDataSourceImpl();
});
