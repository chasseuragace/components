import '../../models/homepage/model.dart';

abstract class HomepageLocalDataSource {
  Future<List<HomepageModel>> getAllItems();
  Future<HomepageModel?> getItemById(String id);
  Future<void> addItem(HomepageModel model);
  Future<void> updateItem(HomepageModel model);
  Future<void> deleteItem(String id);
}

class HomepageLocalDataSourceImpl implements HomepageLocalDataSource {
  @override
  Future<List<HomepageModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<HomepageModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(HomepageModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(HomepageModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
