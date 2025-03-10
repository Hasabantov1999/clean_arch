// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_sentry;

class CleanArchSentry {
  static Future<void> init([
    FlutterOptionsConfiguration? sentryOptions,
  ]) async {
    if (sentryOptions == null) {
      return;
    }
    await SentryFlutter.init(
      sentryOptions,
    );
  }

  static Future<void> reportError(
    dynamic error,
    StackTrace stackTrace,
  ) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }
}
