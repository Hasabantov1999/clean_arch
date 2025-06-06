// ignore: use_string_in_part_of_directives
part of app;

class CleanArchAppWidget extends StatelessWidget {
  const CleanArchAppWidget({
    super.key,
    required this.sentryNavigatorObserver,
    required this.performanceNavigatorObserver,
    this.adaptiveCacheTheme,
    required this.themes,
    this.initialTheme,
    required this.home,
    required this.mainLocale,
    this.config,
    this.sentryOptions,
    this.firebase,
    this.assetsFolder = "assets/i18n",
    this.localizationCache = true,
    this.init,
    required this.designSize,
  });
  final bool sentryNavigatorObserver;
  final bool performanceNavigatorObserver;
  final bool? adaptiveCacheTheme;
  final Future Function()? init;
  final List<CleanArchTheme> themes;
  final CleanArchLocale mainLocale;
  final String? initialTheme;
  final CleanArchRoute home;
  final String? config;
  final FlutterOptionsConfiguration? sentryOptions;
  final CleanArchFireBaseOptions? firebase;
  final String assetsFolder;
  final bool localizationCache;
  final Size designSize;
  @override
  Widget build(BuildContext context) {
    return CleanArchBuilder(
      viewModelBuilder: () => AppController(),
      serviceBuilder: () => AppService(),
      onServiceReady: (service) {
        if (init != null) {
          init!();
        }
      },
      reactive: true,
      builder: (context, controller, child) {
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return SnackyConfiguratorWidget(
              app: CleanArchLocalization(
                mainLocale: mainLocale,
                assetsFolder: assetsFolder,
                child: CleanArchThemeManager(
                  themes: themes,
                  builder: (context, theme) {
                    return MaterialApp(
                      navigatorKey: CleanArchRouter().initialKey,
                      debugShowCheckedModeBanner: false,
                      navigatorObservers: [
                        if (sentryNavigatorObserver) SentryNavigatorObserver(),
                        if (performanceNavigatorObserver)
                          PerformanceNavigatorObserver(),
                        SnackyNavigationObserver(),
                      ],
                      theme: theme,
                      home: CleanArchRouter().platformType(
                        home,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
