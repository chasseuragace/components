import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/jobs/get_all_grouped_jobs_use_case.dart';

import '../../../data/datasources/jobs/local_data_source.dart';
import '../../../data/datasources/jobs/remote_data_source.dart';
import '../../../data/repositories/jobs/repository_impl_fake.dart';
import '../../../domain/usecases/jobs/get_all.dart';
import '../../../domain/usecases/jobs/get_by_id.dart';
import '../../../domain/usecases/jobs/add.dart';
import '../../../domain/usecases/jobs/update.dart';
import '../../../domain/usecases/jobs/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllJobsUseCaseProvider = Provider<GetAllJobsUseCase>((ref) {
  return GetAllJobsUseCase(ref.watch(rJobsRepositoryProvider));
});

final getGroupedJobsUseCaseProvider = Provider<GetAllGroupedJobsUseCase>((ref) {
  return GetAllGroupedJobsUseCase(ref.watch(rJobsRepositoryProvider));
});

final getJobsByIdUseCaseProvider = Provider<GetJobsByIdUseCase>((ref) {
  return GetJobsByIdUseCase(ref.watch(rJobsRepositoryProvider));
});

final addJobsUseCaseProvider = Provider<AddJobsUseCase>((ref) {
  return AddJobsUseCase(ref.watch(rJobsRepositoryProvider));
});

final updateJobsUseCaseProvider = Provider<UpdateJobsUseCase>((ref) {
  return UpdateJobsUseCase(ref.watch(rJobsRepositoryProvider));
});



final deleteJobsUseCaseProvider = Provider<DeleteJobsUseCase>((ref) {
  return DeleteJobsUseCase(ref.watch(rJobsRepositoryProvider));
});

final rJobsRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataJobsSourceProvider);
  final remote = ref.read(remoteDataJobsSourceProvider);
  return JobsRepositoryFake(localDataSource: local, remoteDataSource: remote,storage: ref.read(tokenStorageProvider));
});

final localDataJobsSourceProvider = Provider<JobsLocalDataSource>((ref) {
  return JobsLocalDataSourceImpl();
});

final remoteDataJobsSourceProvider = Provider<JobsRemoteDataSource>((ref) {
  return JobsRemoteDataSourceImpl();
});


