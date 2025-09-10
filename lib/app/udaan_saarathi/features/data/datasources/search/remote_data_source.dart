import '../../models/search/model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchModel>> getAllItems();
  Future<SearchModel?> getItemById(String id);
  Future<void> addItem(SearchModel model);
  Future<void> updateItem(SearchModel model);
  Future<void> deleteItem(String id);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  @override
  Future<List<SearchModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<SearchModel?> getItemById(String id) async {
   throw UnimplementedError();
  }

  @override
  Future<void> addItem(SearchModel model) async {
   throw UnimplementedError();
  }

  @override
  Future<void> updateItem(SearchModel model) async {
   throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
   throw UnimplementedError();
  }
}
