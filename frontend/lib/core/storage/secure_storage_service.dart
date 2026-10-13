import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Tokens and secrets only. Non-sensitive settings use shared_preferences
/// instead — see docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 11 and
/// frontend/lib/core/storage/local_cache_service.dart.
class SecureStorageService {
  SecureStorageService() : _storage = const FlutterSecureStorage();
  final FlutterSecureStorage _storage;

  Future<void> write(String key, String value) => _storage.write(key: key, value: value);
  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> delete(String key) => _storage.delete(key: key);
  Future<void> deleteAll() => _storage.deleteAll();
}
