import '../../../data/datasources/Agency/local_data_source.dart';
import '../../../data/datasources/Agency/remote_data_source.dart';
import '../../../data/repositories/Agency/repository_impl.dart';
import '../../../data/repositories/Agency/repository_impl_fake.dart';
import '../../../domain/usecases/Agency/get_all.dart';
import '../../../domain/usecases/Agency/get_by_id.dart';
import '../../../domain/usecases/Agency/add.dart';
import '../../../domain/usecases/Agency/update.dart';
import '../../../domain/usecases/Agency/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllAgencyUseCaseProvider = Provider<GetAllAgencyUseCase>((ref) {
  return GetAllAgencyUseCase(ref.watch(rAgencyRepositoryProvider));
});

final getAgencyByIdUseCaseProvider = Provider<GetAgencyByIdUseCase>((ref) {
  return GetAgencyByIdUseCase(ref.watch(rAgencyRepositoryProvider));
});

final addAgencyUseCaseProvider = Provider<AddAgencyUseCase>((ref) {
  return AddAgencyUseCase(ref.watch(rAgencyRepositoryProvider));
});

final updateAgencyUseCaseProvider = Provider<UpdateAgencyUseCase>((ref) {
  return UpdateAgencyUseCase(ref.watch(rAgencyRepositoryProvider));
});

final deleteAgencyUseCaseProvider = Provider<DeleteAgencyUseCase>((ref) {
  return DeleteAgencyUseCase(ref.watch(rAgencyRepositoryProvider));
});

final rAgencyRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataAgencySourceProvider);
  final remote = ref.read(remoteDataAgencySourceProvider);
  return AgencyRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataAgencySourceProvider = Provider<AgencyLocalDataSource>((ref) {
  return AgencyLocalDataSourceImpl();
});

final remoteDataAgencySourceProvider = Provider<AgencyRemoteDataSource>((ref) {
  return AgencyRemoteDataSourceImpl();
});
