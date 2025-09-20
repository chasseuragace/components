import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

import '../../../data/datasources/interviews/local_data_source.dart';
import '../../../data/datasources/interviews/remote_data_source.dart';

import '../../../data/repositories/interviews/repository_impl_fake.dart';
import '../../../domain/usecases/interviews/get_all.dart';
import '../../../domain/usecases/interviews/get_by_id.dart';
import '../../../domain/usecases/interviews/add.dart';
import '../../../domain/usecases/interviews/update.dart';
import '../../../domain/usecases/interviews/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllInterviewsUseCaseProvider = Provider<GetAllInterviewsUseCase>((ref) {
  return GetAllInterviewsUseCase(ref.watch(rInterviewsRepositoryProvider));
});

final getInterviewsByIdUseCaseProvider = Provider<GetInterviewsByIdUseCase>((ref) {
  return GetInterviewsByIdUseCase(ref.watch(rInterviewsRepositoryProvider));
});

final addInterviewsUseCaseProvider = Provider<AddInterviewsUseCase>((ref) {
  return AddInterviewsUseCase(ref.watch(rInterviewsRepositoryProvider));
});

final updateInterviewsUseCaseProvider = Provider<UpdateInterviewsUseCase>((ref) {
  return UpdateInterviewsUseCase(ref.watch(rInterviewsRepositoryProvider));
});

final deleteInterviewsUseCaseProvider = Provider<DeleteInterviewsUseCase>((ref) {
  return DeleteInterviewsUseCase(ref.watch(rInterviewsRepositoryProvider));
});

final rInterviewsRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataInterviewsSourceProvider);
  final remote = ref.read(remoteDataInterviewsSourceProvider);
  return InterviewsRepositoryFake(
    storage: ref.read(tokenStorageProvider),
    localDataSource: local, remoteDataSource: remote);
});

final localDataInterviewsSourceProvider = Provider<InterviewsLocalDataSource>((ref) {
  return InterviewsLocalDataSourceImpl();
});

final remoteDataInterviewsSourceProvider = Provider<InterviewsRemoteDataSource>((ref) {
  return InterviewsRemoteDataSourceImpl();
});
