// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_localization;

extension TranslateExtension on String? {
  String? get syncTranslate {
    if (this == null) {
      return null;
    }
    return CleanArchLocalizationService().syncTranslate(this!);
  }
}

extension CleanArchLocalizationExtension on CleanArch {
  void changeLocale(CleanArchLocale locale) {
    if (CleanArchRouter().initialKey.currentContext == null) {
      throw Exception(
        "❌ CleanArchMaterialApp widget bulunamadı! "
        "MaterialApp'in üstüne eklediğinizden emin olun.",
      );
    }
    CleanArchLocalization.of(CleanArchRouter().initialKey.currentContext!)
        .changeLocale(
      locale,
    );
  }
}
