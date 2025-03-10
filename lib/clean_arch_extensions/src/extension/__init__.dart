// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_extensions;

extension CleanArchExtension on CleanArch {
  BuildContext get context {
    if (CleanArchRouter().initialKey.currentContext == null) {
      throw Exception(
        "❌ CleanArchMaterialApp widget bulunamadı! "
        "MaterialApp'in üstüne eklediğinizden emin olun.",
      );
    }
    return CleanArchRouter().initialKey.currentContext!;
  }
}
