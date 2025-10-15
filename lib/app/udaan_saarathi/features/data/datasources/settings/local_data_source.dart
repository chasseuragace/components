import '../../models/Settings/model.dart';

abstract class SettingsLocalDataSource {
  Future<List<SettingsModel>> getAllItems();
  Future<SettingsModel?> getItemById(String id);
  Future<void> addItem(SettingsModel model);
  Future<void> updateItem(SettingsModel model);
  Future<void> deleteItem(String id);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  @override
  Future<List<SettingsModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<SettingsModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(SettingsModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(SettingsModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
