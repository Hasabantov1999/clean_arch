// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_config;

class CleanArchConfig {

  static Future<void> init([String envPath = ".env"]) async {
    await dotenv.load(fileName: envPath);
    
  }

  static String? get(String key) {
    return dotenv.env[key];
  }
}