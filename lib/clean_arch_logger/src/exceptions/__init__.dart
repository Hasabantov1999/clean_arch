// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_logger;

class CleanArchException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  /// **Hata yakalama sınıfı**
  /// - [message]: Hata mesajı.
  /// - [stackTrace]: Hatanın oluştuğu yerin izi (isteğe bağlı).
  CleanArchException(this.message, {this.stackTrace}) {
    logException();
  }

  /// Hata mesajını loglama fonksiyonu
  void logException() {
    developer.log(
      '🔴 EXCEPTION: $message',
      name: 'AppException',
      error: this,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() {
    return 'AppException: $message';
  }
}
