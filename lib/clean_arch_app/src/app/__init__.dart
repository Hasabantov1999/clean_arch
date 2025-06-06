// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_app;

class CleanArchApp {
  final String? config;
  final FlutterOptionsConfiguration? sentryOptions;
  final List<DeviceOrientation>? oriantationModes;
  final CleanArchFireBaseOptions? firebase;
  final bool sentryNavigatorObserver;
  final bool performanceNavigatorObserver;
  final Future Function(
    String message,
    StackTrace stackTrace,
    String timeStamp,
  )? serviceLog;
  final bool? adaptiveCacheTheme;
  final List<CleanArchTheme> themes;
  final String? initialTheme;
  final CleanArchRoute home;
  final CleanArchLocale mainLocale;
  final String localizationAssetsFolder;
  final bool localizationCache;

  /// **Constructor** (Bu sınıfın bir nesnesini oluştururken parametreleri alır)
  CleanArchApp({
    this.config,
    this.sentryOptions,
    this.oriantationModes,
    this.firebase,
    this.sentryNavigatorObserver = false,
    this.performanceNavigatorObserver = false,
    this.serviceLog,
    this.adaptiveCacheTheme,
    required this.themes,
    this.initialTheme,
    required this.home,
    required this.mainLocale,
    this.localizationAssetsFolder = "assets/i18n",
    this.localizationCache = false,
  });

  /// **Uygulamayı oluşturur ve bir Widget döndürür**
  static Future<void> build({
    required String? config,
    required FlutterOptionsConfiguration? sentryOptions,
    required List<DeviceOrientation>? oriantationModes,
    required CleanArchFireBaseOptions? firebase,
    required bool sentryNavigatorObserver,
    required bool performanceNavigatorObserver,
    Future Function()? init,
    Future Function()? mainFuture,
    required Future Function(
      String message,
      StackTrace stackTrace,
      String timeStamp,
    )? serviceLog,
    required bool? adaptiveCacheTheme,
    required List<CleanArchTheme> themes,
    required String? initialTheme,
    required CleanArchRoute home,
    required CleanArchLocale mainLocale,
    String localizationAssetsFolder = "assets/i18n",
    bool localizationCache = true,
    String assetPath = "assets",
    Size designSize = const Size(360, 690),
  }) async {
    runZonedGuarded(
      () async {
        if (config != null) {
          CleanArchLog.instance.logInfo(
            "Config kurulumu başarılı! Path:$config",
          );
          CleanArchConfig.init(config);
        }
        if (mainFuture != null) {
          await mainFuture();
        }
        await CleanArchStorage.instance.init();
        CleanArchInjector.init(CleanArchAsset());
        CleanArchInjector.getInstance<CleanArchAsset>().init(
          assetPath,
        );
        CleanArchLog.instance.logInfo(
          "ASset kurulumu başarılı! Path:$assetPath",
        );
        if (sentryOptions != null) {
          CleanArchLog.instance.logInfo(
            "Sentry Kurulumu Başarılı!",
          );
          SentryFlutter.init(
            sentryOptions,
            appRunner: () => _App(
              config: config,
              sentryOptions: sentryOptions,
              oriantationModes: oriantationModes,
              firebase: firebase,
              sentryNavigatorObserver: sentryNavigatorObserver,
              performanceNavigatorObserver: performanceNavigatorObserver,
              serviceLog: serviceLog,
              adaptiveCacheTheme: adaptiveCacheTheme,
              themes: themes,
              initialTheme: initialTheme,
              home: home,
              mainLocale: mainLocale,
              localizationAssetsFolder: localizationAssetsFolder,
              localizationCache: localizationCache,
              init: init,
              designSize: designSize,
            ),
          );
        }
        CleanArchLog.instance.logInfo(
          "Uygulama Başlatıldı!",
        );

        runApp(
          _App(
            config: config,
            sentryOptions: sentryOptions,
            oriantationModes: oriantationModes,
            firebase: firebase,
            sentryNavigatorObserver: sentryNavigatorObserver,
            performanceNavigatorObserver: performanceNavigatorObserver,
            serviceLog: serviceLog,
            adaptiveCacheTheme: adaptiveCacheTheme,
            themes: themes,
            initialTheme: initialTheme,
            home: home,
            mainLocale: mainLocale,
            localizationAssetsFolder: localizationAssetsFolder,
            localizationCache: true,
            init: init,
            designSize: designSize,
          ),
        );
      },
      (error, stack) {
        CleanArchLog.instance.logError("Hata Yakalandı!\n$error");
        if (serviceLog != null) {
          serviceLog(
            error.toString(),
            stack,
            DateTime.now().toIso8601String(),
          );
        }
        if (sentryOptions != null) {
          Sentry.captureException(
            error,
            stackTrace: stack,
          );
        }
        throw stack;
      },
    );
  }
}

/// **Uygulama Çekirdek Yapısı (`StatefulWidget`)**
class _App extends StatefulWidget {
  const _App({
    this.config,
    this.sentryOptions,
    this.oriantationModes,
    this.firebase,
    this.sentryNavigatorObserver = false,
    this.performanceNavigatorObserver = false,
    this.serviceLog,
    this.adaptiveCacheTheme,
    required this.home,
    this.initialTheme,
    required this.themes,
    required this.mainLocale,
    required this.localizationAssetsFolder,
    required this.localizationCache,
    this.init,
    required this.designSize,
  });

  final String? config;
  final FlutterOptionsConfiguration? sentryOptions;
  final List<DeviceOrientation>? oriantationModes;
  final CleanArchFireBaseOptions? firebase;
  final bool sentryNavigatorObserver;
  final bool performanceNavigatorObserver;
  final String localizationAssetsFolder;
  final bool localizationCache;
  final Future Function()? init;
  final Future Function(
    String message,
    StackTrace stackTrace,
    String timeStamp,
  )? serviceLog;
  final bool? adaptiveCacheTheme;
  final List<CleanArchTheme> themes;
  final String? initialTheme;
  final CleanArchRoute home;
  final CleanArchLocale mainLocale;
  final Size designSize;
  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _App oldWidget) {
    if (oldWidget.config != widget.config ||
        oldWidget.firebase != widget.firebase ||
        widget.oriantationModes != oldWidget.oriantationModes) {
      CleanArchInjector.getInstance<AppService>().update(
        widget.oriantationModes,
        widget.firebase,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CleanArchAppWidget(
      sentryNavigatorObserver: widget.sentryNavigatorObserver,
      performanceNavigatorObserver: widget.performanceNavigatorObserver,
      themes: widget.themes,
      initialTheme: widget.initialTheme,
      home: widget.home,
      mainLocale: widget.mainLocale,
      config: widget.config,
      firebase: widget.firebase,
      init: widget.init,
      sentryOptions: widget.sentryOptions,
      designSize: widget.designSize,
    );
  }
}
