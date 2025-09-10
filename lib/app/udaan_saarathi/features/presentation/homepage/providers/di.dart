import '../../../data/datasources/homepage/local_data_source.dart';
import '../../../data/datasources/homepage/remote_data_source.dart';
import '../../../data/repositories/homepage/repository_impl.dart';
import '../../../data/repositories/homepage/repository_impl_fake.dart';
import '../../../domain/usecases/homepage/get_all.dart';
import '../../../domain/usecases/homepage/get_by_id.dart';
import '../../../domain/usecases/homepage/add.dart';
import '../../../domain/usecases/homepage/update.dart';
import '../../../domain/usecases/homepage/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllHomepageUseCaseProvider = Provider<GetAllHomepageUseCase>((ref) {
  return GetAllHomepageUseCase(ref.watch(rHomepageRepositoryProvider));
});

final getHomepageByIdUseCaseProvider = Provider<GetHomepageByIdUseCase>((ref) {
  return GetHomepageByIdUseCase(ref.watch(rHomepageRepositoryProvider));
});

final addHomepageUseCaseProvider = Provider<AddHomepageUseCase>((ref) {
  return AddHomepageUseCase(ref.watch(rHomepageRepositoryProvider));
});

final updateHomepageUseCaseProvider = Provider<UpdateHomepageUseCase>((ref) {
  return UpdateHomepageUseCase(ref.watch(rHomepageRepositoryProvider));
});

final deleteHomepageUseCaseProvider = Provider<DeleteHomepageUseCase>((ref) {
  return DeleteHomepageUseCase(ref.watch(rHomepageRepositoryProvider));
});

final rHomepageRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataHomepageSourceProvider);
  final remote = ref.read(remoteDataHomepageSourceProvider);
  return HomepageRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataHomepageSourceProvider = Provider<HomepageLocalDataSource>((ref) {
  return HomepageLocalDataSourceImpl();
});

final remoteDataHomepageSourceProvider = Provider<HomepageRemoteDataSource>((ref) {
  return HomepageRemoteDataSourceImpl();
});
