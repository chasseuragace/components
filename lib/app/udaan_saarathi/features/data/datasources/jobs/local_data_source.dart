import '../../models/jobs/model.dart';

abstract class JobsLocalDataSource {
  Future<List<JobsModel>> getAllItems();
  Future<JobsModel?> getItemById(String id);
  Future<void> addItem(JobsModel model);
  Future<void> updateItem(JobsModel model);
  Future<void> deleteItem(String id);
}

class JobsLocalDataSourceImpl implements JobsLocalDataSource {
  @override
  Future<List<JobsModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<JobsModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(JobsModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(JobsModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
