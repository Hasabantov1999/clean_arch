// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_app;

class CleanArchFirebase {
  static final CleanArchFirebase instance = CleanArchFirebase._internal();

  factory CleanArchFirebase() {
    return instance;
  }

  CleanArchFirebase._internal();

  /// **Tüm Firebase Servislerini Başlatır**
  Future<void> initAll({
    required bool crashlytics,
    required bool messaging,
    required bool firestore,
    required bool analytics,
  }) async {
    await initCore();

    if (messaging) {
      initMessaging();
    }
  }

  /// **Firebase Core Başlatma**
  Future<void> initCore() async {
    await Firebase.initializeApp();
  }

  /// **Firebase Authentication**

  /// **Firebase Crashlytics**

  /// **Firebase Cloud Messaging (Bildirimler)**
  FirebaseMessaging? messaging;
  Future<void> initMessaging() async {
    messaging = FirebaseMessaging.instance;
    await messaging?.requestPermission();
  }

  /// **Cloud Firestore**

  /// **Firebase Analytics**
}
