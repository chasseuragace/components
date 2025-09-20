import '../../models/interviews/model.dart';

abstract class InterviewsRemoteDataSource {
  Future<List<InterviewsModel>> getAllItems();
  Future<InterviewsModel?> getItemById(String id);
  Future<void> addItem(InterviewsModel model);
  Future<void> updateItem(InterviewsModel model);
  Future<void> deleteItem(String id);
}

class InterviewsRemoteDataSourceImpl implements InterviewsRemoteDataSource {
  @override
  Future<List<InterviewsModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<InterviewsModel?> getItemById(String id) async {
   throw UnimplementedError();
  }

  @override
  Future<void> addItem(InterviewsModel model) async {
   throw UnimplementedError();
  }

  @override
  Future<void> updateItem(InterviewsModel model) async {
   throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
   throw UnimplementedError();
  }
}
