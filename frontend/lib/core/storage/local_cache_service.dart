import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive settings and cached flags only (onboarding, theme mode,
/// speaking pace). Never tokens or secrets — those belong in
/// secure_storage_service.dart. See docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 11.
class LocalCacheService {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<void> setString(String key, String value) async => (await _prefs).setString(key, value);
  Future<String?> getString(String key) async => (await _prefs).getString(key);

  Future<void> setInt(String key, int value) async => (await _prefs).setInt(key, value);
  Future<int?> getInt(String key) async => (await _prefs).getInt(key);

  Future<void> setBool(String key, bool value) async => (await _prefs).setBool(key, value);
  Future<bool?> getBool(String key) async => (await _prefs).getBool(key);

  Future<void> clearOnLogout() async {
    final prefs = await _prefs;
    // Invalidate caches that are per-account on logout/account switch,
    // per docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 11 caching rules.
    await prefs.remove('cached_default_workspace_id');
  }
}
