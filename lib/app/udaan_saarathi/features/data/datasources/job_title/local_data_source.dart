import '../../models/job_title/model.dart';

abstract class JobTitleLocalDataSource {
  Future<List<JobTitleModel>> getAllItems();
  Future<JobTitleModel?> getItemById(String id);
  Future<void> addItem(JobTitleModel model);
  Future<void> updateItem(JobTitleModel model);
  Future<void> deleteItem(String id);
}

class JobTitleLocalDataSourceImpl implements JobTitleLocalDataSource {
  @override
  Future<List<JobTitleModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<JobTitleModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(JobTitleModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(JobTitleModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
