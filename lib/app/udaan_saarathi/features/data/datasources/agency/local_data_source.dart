import '../../models/Agency/model.dart';

abstract class AgencyLocalDataSource {
  Future<List<AgencyModel>> getAllItems();
  Future<AgencyModel?> getItemById(String id);
  Future<void> addItem(AgencyModel model);
  Future<void> updateItem(AgencyModel model);
  Future<void> deleteItem(String id);
}

class AgencyLocalDataSourceImpl implements AgencyLocalDataSource {
  @override
  Future<List<AgencyModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<AgencyModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(AgencyModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(AgencyModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
