import '../../models/preferences/model.dart';

abstract class PreferencesLocalDataSource {
  Future<List<PreferencesModel>> getAllItems();
  Future<PreferencesModel?> getItemById(String id);
  Future<void> addItem(PreferencesModel model);
  Future<void> updateItem(PreferencesModel model);
  Future<void> deleteItem(String id);
}

class PreferencesLocalDataSourceImpl implements PreferencesLocalDataSource {
  @override
  Future<List<PreferencesModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<PreferencesModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(PreferencesModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(PreferencesModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
