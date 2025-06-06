// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_config;

class CleanArchConfig {
  static Future<void> init([String envPath = ".env"]) async {
    await dotenv.load(fileName: envPath);
  }

  static String? get(String key) {
    return dotenv.env[key];
  }

  static String? setSecret(String key, dynamic value) {
    _appConfigs[key] = value;
    return null;
  }

  static getSecret(String key) {
    if(_appConfigs[key] == null) {
      throw Exception("Secret not found");
    }
    return _appConfigs[key];
  }

  static Map<String, dynamic> _appConfigs = {};
}
