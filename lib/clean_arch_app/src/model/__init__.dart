// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_app;

class CleanArchFireBaseOptions {
  final bool firebase;
  final bool crashlytics;
  final bool messaging;
  final bool firestore;
  final bool analytics;
  CleanArchFireBaseOptions({
    required this.firebase,
    this.analytics = false,
    this.crashlytics = false,
    this.firestore = false,
    this.messaging = false,
  });
}
