import '../../../data/datasources/Favorites/local_data_source.dart';
import '../../../data/datasources/Favorites/remote_data_source.dart';
import '../../../data/repositories/Favorites/repository_impl.dart';
import '../../../data/repositories/Favorites/repository_impl_fake.dart';
import '../../../domain/usecases/Favorites/get_all.dart';
import '../../../domain/usecases/Favorites/get_by_id.dart';
import '../../../domain/usecases/Favorites/add.dart';
import '../../../domain/usecases/Favorites/update.dart';
import '../../../domain/usecases/Favorites/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllFavoritesUseCaseProvider = Provider<GetAllFavoritesUseCase>((ref) {
  return GetAllFavoritesUseCase(ref.watch(rFavoritesRepositoryProvider));
});

final getFavoritesByIdUseCaseProvider = Provider<GetFavoritesByIdUseCase>((ref) {
  return GetFavoritesByIdUseCase(ref.watch(rFavoritesRepositoryProvider));
});

final addFavoritesUseCaseProvider = Provider<AddFavoritesUseCase>((ref) {
  return AddFavoritesUseCase(ref.watch(rFavoritesRepositoryProvider));
});

final updateFavoritesUseCaseProvider = Provider<UpdateFavoritesUseCase>((ref) {
  return UpdateFavoritesUseCase(ref.watch(rFavoritesRepositoryProvider));
});

final deleteFavoritesUseCaseProvider = Provider<DeleteFavoritesUseCase>((ref) {
  return DeleteFavoritesUseCase(ref.watch(rFavoritesRepositoryProvider));
});

final rFavoritesRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataFavoritesSourceProvider);
  final remote = ref.read(remoteDataFavoritesSourceProvider);
  return FavoritesRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataFavoritesSourceProvider = Provider<FavoritesLocalDataSource>((ref) {
  return FavoritesLocalDataSourceImpl();
});

final remoteDataFavoritesSourceProvider = Provider<FavoritesRemoteDataSource>((ref) {
  return FavoritesRemoteDataSourceImpl();
});
