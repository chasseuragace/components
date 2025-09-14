import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction for key-value local storage
abstract class LocalStorage {
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> remove(String key);
}

/// Riverpod provider for SharedPreferences, must be overridden in main()
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

/// Implementation of LocalStorage using SharedPreferences
class SharedPrefsLocalStorage implements LocalStorage {
  SharedPrefsLocalStorage(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }
}

/// LocalStorage provider that uses the sharedPreferencesProvider
final localStorageProvider = Provider<LocalStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPrefsLocalStorage(prefs);
});