// ignore_for_file: library_private_types_in_public_api

// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_localization;

class CleanArchLocalization extends StatefulWidget {
  const CleanArchLocalization({
    super.key,
    required this.mainLocale,
    this.assetsFolder = "assets/i18n",
    required this.child,
    this.cache = true,
  });

  final CleanArchLocale mainLocale;
  final String assetsFolder;
  final Widget child;
  final bool cache;

  static _HYTLocalizationInherited of(BuildContext context) {
    final inheritedWidget =
        context.dependOnInheritedWidgetOfExactType<_HYTLocalizationInherited>();
    if (inheritedWidget == null) {
      throw FlutterError(
          'HYTLocalization widget is missing in the widget tree.');
    }
    return inheritedWidget;
  }

  @override
  State<CleanArchLocalization> createState() => _CleanArchLocalizationState();
}

class _CleanArchLocalizationState extends State<CleanArchLocalization> {
  late String currentLocale;
  static const String _localeCacheKey = 'cached_locale';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocalization();
  }

  Future<void> _initializeLocalization() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedLocale = prefs.getString(_localeCacheKey);

    // Cache'deki dil yoksa mainLocale kullanılır
    currentLocale = cachedLocale ?? widget.mainLocale.locale;

    // LocalizationManager'i başlat
    await CleanArchLocalizationService().init(
      initialLocale: currentLocale,
      assetsFolder: widget.assetsFolder,
      mainLocale: widget.mainLocale.locale,
      cache: widget.cache,
    );
    CleanArchLog.instance.logInfo(
      "Localization Framework Kurlumu Tamamlandı",
    );
    if (mounted) {
      setState(() {
        _isLoading = false; // Yükleme işlemi tamamlandı
      });
    }
  }

  Future<CleanArchLocale> get getLocale async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(_localeCacheKey);
    return CleanArchLocale(
      locale: locale ?? widget.mainLocale.locale,
    );
  }

  Future<void> changeLocale(CleanArchLocale newLocale) async {
    if (newLocale.locale != currentLocale) {
      setState(() {
        currentLocale = newLocale.locale;
        CleanArchLocalizationService().initialLocale = newLocale.locale;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeCacheKey, newLocale.locale);
      await CleanArchLocalizationService().loadAssets();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return _HYTLocalizationInherited(
      locale: currentLocale,
      changeLocale: changeLocale,
      child: widget.child,
    );
  }
}

class _HYTLocalizationInherited extends InheritedWidget {
  final String locale;
  final void Function(CleanArchLocale) changeLocale;

  const _HYTLocalizationInherited({
    required this.locale,
    required this.changeLocale,
    required super.child,
  });

  @override
  bool updateShouldNotify(_HYTLocalizationInherited oldWidget) {
    return locale != oldWidget.locale;
  }
}
