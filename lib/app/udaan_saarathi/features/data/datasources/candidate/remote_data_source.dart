import '../../models/candidate/model.dart';

abstract class CandidateRemoteDataSource {
  Future<List<CandidateModel>> getAllItems();
  Future<CandidateModel?> getItemById(String id);
  Future<void> addItem(CandidateModel model);
  Future<void> updateItem(CandidateModel model);
  Future<void> deleteItem(String id);
}

class CandidateRemoteDataSourceImpl implements CandidateRemoteDataSource {
  @override
  Future<List<CandidateModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<CandidateModel?> getItemById(String id) async {
   throw UnimplementedError();
  }

  @override
  Future<void> addItem(CandidateModel model) async {
   throw UnimplementedError();
  }

  @override
  Future<void> updateItem(CandidateModel model) async {
   throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
   throw UnimplementedError();
  }
}
