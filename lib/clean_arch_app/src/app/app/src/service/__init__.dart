// ignore_for_file: use_string_in_part_of_directives

part of app;

class AppService extends CleanArchBaseService {
  @override
  void init() {}

  @override
  void dispose() {}
  void update([

    List<DeviceOrientation>? oriantationModes,
    CleanArchFireBaseOptions? firebase,
  ]) {

    _initializeOriantationModes(
      oriantationModes,
    );
    _initializeFirebase(
      firebase,
    );
  }


  void _initializeOriantationModes(
      [List<DeviceOrientation>? oriantationModes]) {
    if (oriantationModes != null && oriantationModes.isNotEmpty) {
      CleanArchLog.instance.logInfo(
        "OriantationMode kurulumu başarılı! Values:$oriantationModes",
      );
      SystemChrome.setPreferredOrientations(oriantationModes);
    }
  }

  void _initializeFirebase([CleanArchFireBaseOptions? firebase]) {
    if (firebase != null) {
            CleanArchLog.instance.logInfo(
        "Firebase Kurulumu Başarılı\nFirebase:on\nFirebase Crashlytics:${firebase.crashlytics ? "on" : "off"}\nFirebase Messaging:${firebase.messaging ? "on" : "off"}\nFirebase Firestore:${firebase.firestore ? "on" : "off"}\nFirebase Analytics:${firebase.analytics ? "on" : "off"}",
      );
      CleanArchFirebase.instance.initAll(
        crashlytics: firebase.crashlytics,
        messaging: firebase.messaging,
        firestore: firebase.firebase,
        analytics: firebase.analytics,
      );
    }
  }
}
