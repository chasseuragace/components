import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/applicaitons/apply_job.dart';

import '../../../data/datasources/applicaitons/local_data_source.dart';
import '../../../data/datasources/applicaitons/remote_data_source.dart';
import '../../../data/repositories/applicaitons/repository_impl_fake.dart';

import '../../../domain/usecases/applicaitons/delete.dart';
import '../../../domain/usecases/applicaitons/get_all.dart';
import '../../../domain/usecases/applicaitons/get_by_id.dart';
import '../../../domain/usecases/applicaitons/update.dart';

final getAllApplicaitonsUseCaseProvider =
    Provider<GetAllApplicaitonsUseCase>((ref) {
  return GetAllApplicaitonsUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final getApplicaitonsByIdUseCaseProvider =
    Provider<GetApplicaitonsByIdUseCase>((ref) {
  return GetApplicaitonsByIdUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});


final applyJobUseCaseProvider = Provider<ApplyJobUseCase>((ref) {
  return ApplyJobUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final updateApplicaitonsUseCaseProvider =
    Provider<UpdateApplicaitonsUseCase>((ref) {
  return UpdateApplicaitonsUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final deleteApplicaitonsUseCaseProvider =
    Provider<DeleteApplicaitonsUseCase>((ref) {
  return DeleteApplicaitonsUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final rApplicaitonsRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataApplicaitonsSourceProvider);
  final remote = ref.read(remoteDataApplicaitonsSourceProvider);
  final storage = ref.read(tokenStorageProvider);

  return ApplicaitonsRepositoryFake(
      localDataSource: local, remoteDataSource: remote, storage: storage);
});

final localDataApplicaitonsSourceProvider =
    Provider<ApplicaitonsLocalDataSource>((ref) {
  return ApplicaitonsLocalDataSourceImpl();
});

final remoteDataApplicaitonsSourceProvider =
    Provider<ApplicaitonsRemoteDataSource>((ref) {
  return ApplicaitonsRemoteDataSourceImpl();
});
