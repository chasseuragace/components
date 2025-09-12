import '../../../data/datasources/job_title/local_data_source.dart';
import '../../../data/datasources/job_title/remote_data_source.dart';
import '../../../data/repositories/job_title/repository_impl.dart';
import '../../../data/repositories/job_title/repository_impl_fake.dart';
import '../../../domain/usecases/job_title/get_all.dart';
import '../../../domain/usecases/job_title/get_by_id.dart';
import '../../../domain/usecases/job_title/add.dart';
import '../../../domain/usecases/job_title/update.dart';
import '../../../domain/usecases/job_title/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllJobTitleUseCaseProvider = Provider<GetAllJobTitleUseCase>((ref) {
  return GetAllJobTitleUseCase(ref.watch(rJobTitleRepositoryProvider));
});

final getJobTitleByIdUseCaseProvider = Provider<GetJobTitleByIdUseCase>((ref) {
  return GetJobTitleByIdUseCase(ref.watch(rJobTitleRepositoryProvider));
});

final addJobTitleUseCaseProvider = Provider<AddJobTitleUseCase>((ref) {
  return AddJobTitleUseCase(ref.watch(rJobTitleRepositoryProvider));
});

final updateJobTitleUseCaseProvider = Provider<UpdateJobTitleUseCase>((ref) {
  return UpdateJobTitleUseCase(ref.watch(rJobTitleRepositoryProvider));
});

final deleteJobTitleUseCaseProvider = Provider<DeleteJobTitleUseCase>((ref) {
  return DeleteJobTitleUseCase(ref.watch(rJobTitleRepositoryProvider));
});

final rJobTitleRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataJobTitleSourceProvider);
  final remote = ref.read(remoteDataJobTitleSourceProvider);
  return JobTitleRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataJobTitleSourceProvider = Provider<JobTitleLocalDataSource>((ref) {
  return JobTitleLocalDataSourceImpl();
});

final remoteDataJobTitleSourceProvider = Provider<JobTitleRemoteDataSource>((ref) {
  return JobTitleRemoteDataSourceImpl();
});
