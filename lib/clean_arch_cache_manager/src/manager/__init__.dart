// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_cache_manager;

class CleanArchStorage {
  static final CleanArchStorage instance = CleanArchStorage._internal();
   SharedPreferences? _prefs;

  CleanArchStorage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    CleanArchLog.instance.logInfo(
      "Storage Kurulumu Başarılı!",
    );
  }

  Future<void> set(String key, String value) async {
    await _prefs?.setString(key, value);
  }

   Future<String?> get(String key) async {
    return _prefs?.getString(key);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
}
