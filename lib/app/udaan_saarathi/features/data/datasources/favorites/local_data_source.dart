import '../../models/Favorites/model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoritesModel>> getAllItems();
  Future<FavoritesModel?> getItemById(String id);
  Future<void> addItem(FavoritesModel model);
  Future<void> updateItem(FavoritesModel model);
  Future<void> deleteItem(String id);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  @override
  Future<List<FavoritesModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<FavoritesModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(FavoritesModel model) async {
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
