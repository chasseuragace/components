import '../../../data/datasources/candidate/local_data_source.dart';
import '../../../data/datasources/candidate/remote_data_source.dart';
import '../../../data/repositories/candidate/repository_impl_fake.dart';
import '../../../domain/usecases/candidate/get_all.dart';
import '../../../domain/usecases/candidate/get_by_id.dart';
import '../../../domain/usecases/candidate/add.dart';
import '../../../domain/usecases/candidate/update.dart';
import '../../../domain/usecases/candidate/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllCandidateUseCaseProvider = Provider<GetAllCandidateUseCase>((ref) {
  return GetAllCandidateUseCase(ref.watch(rCandidateRepositoryProvider));
});

final getCandidateByIdUseCaseProvider = Provider<GetCandidateByIdUseCase>((ref) {
  return GetCandidateByIdUseCase(ref.watch(rCandidateRepositoryProvider));
});

final addCandidateUseCaseProvider = Provider<AddCandidateUseCase>((ref) {
  return AddCandidateUseCase(ref.watch(rCandidateRepositoryProvider));
});

final updateCandidateUseCaseProvider = Provider<UpdateCandidateUseCase>((ref) {
  return UpdateCandidateUseCase(ref.watch(rCandidateRepositoryProvider));
});

final deleteCandidateUseCaseProvider = Provider<DeleteCandidateUseCase>((ref) {
  return DeleteCandidateUseCase(ref.watch(rCandidateRepositoryProvider));
});

final rCandidateRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataCandidateSourceProvider);
  final remote = ref.read(remoteDataCandidateSourceProvider);
  return CandidateRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataCandidateSourceProvider = Provider<CandidateLocalDataSource>((ref) {
  return CandidateLocalDataSourceImpl();
});

final remoteDataCandidateSourceProvider = Provider<CandidateRemoteDataSource>((ref) {
  return CandidateRemoteDataSourceImpl();
});
