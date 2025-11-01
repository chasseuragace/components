import '../../models/applicaitons/model.dart';

abstract class ApplicaitonsLocalDataSource {
  Future<List<ApplicaitonsModel>> getAllItems();
  Future<ApplicaitonsModel?> getItemById(String id);
  Future<void> addItem(ApplicaitonsModel model);
  Future<void> updateItem(ApplicaitonsModel model);
  Future<void> deleteItem(String id);
}

class ApplicaitonsLocalDataSourceImpl implements ApplicaitonsLocalDataSource {
  @override
  Future<List<ApplicaitonsModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<ApplicaitonsModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(ApplicaitonsModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(ApplicaitonsModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
