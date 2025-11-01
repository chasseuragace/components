import '../../models/profile/model.dart';

abstract class ProfileLocalDataSource {
  Future<List<ProfileModel>> getAllItems();
  Future<ProfileModel?> getItemById(String id);
  Future<void> addItem(ProfileModel model);
  Future<void> updateItem(ProfileModel model);
  Future<void> deleteItem(String id);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<List<ProfileModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<ProfileModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(ProfileModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(ProfileModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
