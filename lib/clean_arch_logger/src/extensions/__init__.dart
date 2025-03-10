// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_logger;
extension LoggerExtension on CleanArch {
  CleanArchLog get logger => CleanArchLog.instance;
}
