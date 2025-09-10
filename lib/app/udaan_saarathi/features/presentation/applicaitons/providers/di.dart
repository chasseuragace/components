import '../../../data/datasources/applicaitons/local_data_source.dart';
import '../../../data/datasources/applicaitons/remote_data_source.dart';
import '../../../data/repositories/applicaitons/repository_impl.dart';
import '../../../data/repositories/applicaitons/repository_impl_fake.dart';
import '../../../domain/usecases/applicaitons/get_all.dart';
import '../../../domain/usecases/applicaitons/get_by_id.dart';
import '../../../domain/usecases/applicaitons/add.dart';
import '../../../domain/usecases/applicaitons/update.dart';
import '../../../domain/usecases/applicaitons/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllApplicaitonsUseCaseProvider = Provider<GetAllApplicaitonsUseCase>((ref) {
  return GetAllApplicaitonsUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final getApplicaitonsByIdUseCaseProvider = Provider<GetApplicaitonsByIdUseCase>((ref) {
  return GetApplicaitonsByIdUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final addApplicaitonsUseCaseProvider = Provider<AddApplicaitonsUseCase>((ref) {
  return AddApplicaitonsUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final updateApplicaitonsUseCaseProvider = Provider<UpdateApplicaitonsUseCase>((ref) {
  return UpdateApplicaitonsUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final deleteApplicaitonsUseCaseProvider = Provider<DeleteApplicaitonsUseCase>((ref) {
  return DeleteApplicaitonsUseCase(ref.watch(rApplicaitonsRepositoryProvider));
});

final rApplicaitonsRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataApplicaitonsSourceProvider);
  final remote = ref.read(remoteDataApplicaitonsSourceProvider);
  return ApplicaitonsRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataApplicaitonsSourceProvider = Provider<ApplicaitonsLocalDataSource>((ref) {
  return ApplicaitonsLocalDataSourceImpl();
});

final remoteDataApplicaitonsSourceProvider = Provider<ApplicaitonsRemoteDataSource>((ref) {
  return ApplicaitonsRemoteDataSourceImpl();
});
