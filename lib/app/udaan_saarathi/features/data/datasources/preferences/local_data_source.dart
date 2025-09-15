import 'dart:convert';
import '../../../../core/storage/local_storage.dart';
import '../../models/preferences/model.dart';


abstract class PreferencesLocalDataSource {
  Future<List<PreferencesModel>> getAllItems();
  Future<PreferencesModel?> getItemById(String id);
  Future<void> addItem(PreferencesModel model);
  Future<void> updateItem(PreferencesModel model);
  Future<void> deleteItem(String id);
  Future<Map<String, dynamic>?> getFilter();
}

class PreferencesLocalDataSourceImpl implements PreferencesLocalDataSource {
  final LocalStorage _localStorage;
  
  PreferencesLocalDataSourceImpl(this._localStorage);
  
  @override
  Future<List<PreferencesModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<PreferencesModel?> getItemById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addItem(PreferencesModel model) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateItem(PreferencesModel model) async {
    // Save filter template data (excluding job titles) to 'filter_data' key
    // This ensures what we save matches what getFilter() loads
    final filterJson = json.encode(model.rawJson);
    await _localStorage.setString('filter_data', filterJson);
    
    // Also save as individual preference item for backup/history
    await _localStorage.setString('user_preferences_${model.id}', filterJson);
    
    // Save metadata
    final metadata = {
      'id': model.id,
      'jobTitleId': model.jobTitleId,
      'name': model.title,
      'lastModified': DateTime.now().toIso8601String(),
    };
    await _localStorage.setString('user_preferences_${model.id}_meta', json.encode(metadata));
    
    // Update the list of saved preferences
    final existingListJson = await _localStorage.getString('user_preferences_list');
    List<String> existingIds = [];
    if (existingListJson != null) {
      final decoded = json.decode(existingListJson);
      if (decoded is List) {
        existingIds = decoded.cast<String>();
      }
    }
    
    if (!existingIds.contains(model.id)) {
      existingIds.add(model.id);
      await _localStorage.setString('user_preferences_list', json.encode(existingIds));
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, dynamic>?> getFilter() async {
    // Get filter data from local storage
    final filterJson = await _localStorage.getString('filter_data');
    if (filterJson != null) {
      try {
        return json.decode(filterJson) as Map<String, dynamic>;
      } catch (e) {
        // If parsing fails, return default filter
        return _getDefaultFilter();
      }
    }
    
    // Return default filter if no local data
    return _getDefaultFilter();
  }
  
  Map<String, dynamic> _getDefaultFilter() {
    return {
      'countries': [
        {
          'label': 'Bulgaria',
          'value': '4b62a218-3849-4909-87bc-6434f07b75d5',
        },
        {
          'label': 'Cyprus',
          'value': '54fb3d0e-f55c-4bc3-97dd-18cb5b406bef',
        },
      ],
      'salaryRange': {
        'min': 800.0,
        'max': 3600.0,
      },
      'industries': <String>[],
      'workLocations': <String>[],
      'workCulture': <String>[],
      'agencies': <String>[],
      'companySize': '',
      'shiftPreferences': <String>[],
      'experienceLevel': '',
      'trainingSupport': false,
      'contractDuration': '',
      'benefits': <String>[],
    };
  }
}
