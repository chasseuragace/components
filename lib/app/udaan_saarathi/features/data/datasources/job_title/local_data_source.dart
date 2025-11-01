import '../../models/job_title/model.dart';

abstract class JobTitleLocalDataSource {
  Future<List<JobTitle>> getAllItems();
  Future<JobTitle?> getItemById(String id);
  Future<void> addItem(JobTitle model);
  Future<void> updateItem(JobTitle model);
  Future<void> deleteItem(String id);
}

class JobTitleLocalDataSourceImpl implements JobTitleLocalDataSource {
  @override
  Future<List<JobTitle>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<JobTitle?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(JobTitle model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(JobTitle model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
