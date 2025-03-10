// ignore_for_file: use_string_in_part_of_directives, non_constant_identifier_names

part of clean_arch_theme;

extension CleanArchThemeExtension on CleanArch {
  void changeTheme(String themeName) {
    if (CleanArchRouter().initialKey.currentContext == null) {
      throw Exception(
        "❌ CleanArchMaterialApp widget bulunamadı! "
        "MaterialApp'in üstüne eklediğinizden emin olun.",
      );
    }
    CleanArchThemeManager.of(CleanArchRouter().initialKey.currentContext!)
        .changeTheme(
      themeName,
    );
  }

  ThemeData get getTheme {
    if (CleanArchRouter().initialKey.currentContext == null) {
      final Brightness systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      bool isDarkMode = systemBrightness == Brightness.dark;

      return isDarkMode ? ThemeData.dark() : ThemeData.light();
    }
    return CleanArchThemeManager.of(
      CleanArchRouter().initialKey.currentContext!,
    ).getTheme;
  }
}
