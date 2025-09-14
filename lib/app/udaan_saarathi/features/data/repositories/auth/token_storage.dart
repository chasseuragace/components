import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';

class TokenStorage {
  static const _kAuthTokenKey = 'auth_token';
  final LocalStorage _storage;

  TokenStorage(this._storage);

  Future<String?> getToken() async {
    return _storage.getString(_kAuthTokenKey);
  }

  Future<void> setToken(String token) async {
    await _storage.setString(_kAuthTokenKey, token);
  }

  Future<void> clearToken() async {
    await _storage.remove(_kAuthTokenKey);
  }
}

/// Provider for TokenStorage using LocalStorage
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final storage = ref.watch(localStorageProvider);
  return TokenStorage(storage);
});
