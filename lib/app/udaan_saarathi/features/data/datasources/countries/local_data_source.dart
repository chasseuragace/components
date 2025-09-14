import '../../models/Countries/model.dart';

abstract class CountriesLocalDataSource {
  Future<List<CountriesModel>> getAllItems();
  Future<CountriesModel?> getItemById(String id);
  Future<void> addItem(CountriesModel model);
  Future<void> updateItem(CountriesModel model);
  Future<void> deleteItem(String id);
}

class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  @override
  Future<List<CountriesModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<CountriesModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(CountriesModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(CountriesModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
