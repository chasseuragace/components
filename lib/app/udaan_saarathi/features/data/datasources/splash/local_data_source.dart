import '../../models/splash/model.dart';

abstract class SplashLocalDataSource {
  Future<List<SplashModel>> getAllItems();
  Future<SplashModel?> getItemById(String id);
  Future<void> addItem(SplashModel model);
  Future<void> updateItem(SplashModel model);
  Future<void> deleteItem(String id);
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  @override
  Future<List<SplashModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<SplashModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(SplashModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(SplashModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
