import '../../models/notifications/model.dart';

abstract class NotificationsLocalDataSource {
  Future<List<NotificationsModel>> getAllItems();
  Future<NotificationsModel?> getItemById(String id);
  Future<void> addItem(NotificationsModel model);
  Future<void> updateItem(NotificationsModel model);
  Future<void> deleteItem(String id);
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  @override
  Future<List<NotificationsModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<NotificationsModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(NotificationsModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(NotificationsModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
