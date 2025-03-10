
// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_logger;
class CleanArchLog {
  static final CleanArchLog instance = CleanArchLog._internal();

  factory CleanArchLog() => instance;

  CleanArchLog._internal();

  // Blue text
  void logInfo(Object msg) {

      developer.log('\x1B[34m${msg.toString()}\x1B[0m');

  }

// Green text
  void logSuccess(Object msg) {

      developer.log('\x1B[32m${msg.toString()}\x1B[0m');
    
  }

// Yellow text
  void logWarning(Object msg) {
    if (kDebugMode) {
      developer.log('\x1B[33m${msg.toString()}\x1B[0m');
    }
  }

// Red text
  void logError(Object msg) {

      developer.log('\x1B[31m${msg.toString()}\x1B[0m');
    
  }

  void logChat(Object msg) {

      developer.log('\x1B[30m\x1b[42m${msg.toString()}\x1B[0m');
    
  }
}
