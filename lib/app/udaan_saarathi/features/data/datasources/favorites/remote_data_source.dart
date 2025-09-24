import '../../models/Favorites/model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoritesModel>> getAllItems();
  Future<FavoritesModel?> getItemById(String id);
  Future<void> addItem({required String jobId});
  Future<void> updateItem(FavoritesModel model);
  Future<void> deleteItem(String id);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  @override
  Future<List<FavoritesModel>> getAllItems() async {
    throw UnimplementedError();
  }

  @override
  Future<FavoritesModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem({required String jobId}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(FavoritesModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
