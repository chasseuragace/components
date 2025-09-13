import '../../../data/datasources/search/local_data_source.dart';
import '../../../data/datasources/search/remote_data_source.dart';
import '../../../data/repositories/search/repository_impl_fake.dart';
import '../../../domain/usecases/search/get_all.dart';
import '../../../domain/usecases/search/get_by_id.dart';
import '../../../domain/usecases/search/add.dart';
import '../../../domain/usecases/search/update.dart';
import '../../../domain/usecases/search/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllSearchUseCaseProvider = Provider<GetAllSearchUseCase>((ref) {
  return GetAllSearchUseCase(ref.watch(rSearchRepositoryProvider));
});

final getSearchByIdUseCaseProvider = Provider<GetSearchByIdUseCase>((ref) {
  return GetSearchByIdUseCase(ref.watch(rSearchRepositoryProvider));
});

final addSearchUseCaseProvider = Provider<AddSearchUseCase>((ref) {
  return AddSearchUseCase(ref.watch(rSearchRepositoryProvider));
});

final updateSearchUseCaseProvider = Provider<UpdateSearchUseCase>((ref) {
  return UpdateSearchUseCase(ref.watch(rSearchRepositoryProvider));
});

final deleteSearchUseCaseProvider = Provider<DeleteSearchUseCase>((ref) {
  return DeleteSearchUseCase(ref.watch(rSearchRepositoryProvider));
});

final rSearchRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataSearchSourceProvider);
  final remote = ref.read(remoteDataSearchSourceProvider);
  return SearchRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataSearchSourceProvider = Provider<SearchLocalDataSource>((ref) {
  return SearchLocalDataSourceImpl();
});

final remoteDataSearchSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSourceImpl();
});
