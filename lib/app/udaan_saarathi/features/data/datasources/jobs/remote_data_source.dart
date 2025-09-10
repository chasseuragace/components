import '../../models/jobs/model.dart';

abstract class JobsRemoteDataSource {
  Future<List<JobsModel>> getAllItems();
  Future<JobsModel?> getItemById(String id);
  Future<void> addItem(JobsModel model);
  Future<void> updateItem(JobsModel model);
  Future<void> deleteItem(String id);
}

class JobsRemoteDataSourceImpl implements JobsRemoteDataSource {
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
