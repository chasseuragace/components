import '../../models/onboarding/model.dart';

abstract class OnboardingLocalDataSource {
  Future<List<OnboardingModel>> getAllItems();
  Future<OnboardingModel?> getItemById(String id);
  Future<void> addItem(OnboardingModel model);
  Future<void> updateItem(OnboardingModel model);
  Future<void> deleteItem(String id);
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  Future<List<OnboardingModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<OnboardingModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(OnboardingModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(OnboardingModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
}
