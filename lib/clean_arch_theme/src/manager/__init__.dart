// ignore_for_file: use_string_in_part_of_directives, library_private_types_in_public_api, use_super_parameters

part of clean_arch_theme;

class CleanArchThemeManager extends StatefulWidget {
  final List<CleanArchTheme> themes;
  final Widget Function(
    BuildContext context,
    ThemeData theme,
  ) builder;
  const CleanArchThemeManager({
    super.key,
    required this.themes,
    required this.builder,
  });

  @override
  State<CleanArchThemeManager> createState() => _CleanArchThemeManagerState();

  static _CleanArchThemeManagerState of(BuildContext context) {
    final _CleanArchThemeManagerState? inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<_InheritedChangeTheme>()
        ?.data;
    if (inheritedTheme == null) {
      throw Exception("❌ CleanArchThemeManager bulunamadı! "
          "MaterialApp'in üstüne eklediğinizden emin olun.");
    }
    return inheritedTheme;
  }
}

class _CleanArchThemeManagerState extends State<CleanArchThemeManager>
    with WidgetsBindingObserver {
  late ThemeData _themeData;
  static const String _themeKey = "selected_theme";
  bool _isDarkMode = false;

  ThemeData get getTheme => _themeData;

  @override
  void initState() {
    _themeData = _getTheme(null);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initTheme();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initTheme();
    }
  }

  @override
  void didChangePlatformBrightness() {
    _initTheme();
  }

  @override
  void didUpdateWidget(CleanArchThemeManager oldWidget) {
    _initTheme();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString(_themeKey);
    CleanArchLog.instance.logChat("Tema Kurulumu Tamamlandı!");
    setState(() {
      _themeData = _getTheme(savedTheme);
    });
  }

  ThemeData _getTheme(String? savedTheme) {
    final Brightness systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _isDarkMode = systemBrightness == Brightness.dark;

    ThemeData themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();

    for (var theme in widget.themes) {
      if (theme.themeName == (savedTheme ?? (_isDarkMode ? "dark" : "light"))) {
        themeData = theme.palette;
        CleanArchLog.instance.logChat(
          "Sisteme Kayıtlı Tema:${theme.themeName}",
        );
        break;
      }
    }
    
    return themeData;
  }

  Future<void> changeTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_themeKey, themeName);

    _themeData = _getTheme(themeName);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    CleanArchLog.instance.logSuccess("Tema Değiştirildi!");
    CleanArchLog.instance.logSuccess("Uygulama Teması:$themeName");
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedChangeTheme(
      data: this,
      child: widget.builder(
        context,
        _themeData,
      ),
    );
  }
}

class _InheritedChangeTheme extends InheritedWidget {
  final _CleanArchThemeManagerState data;

  const _InheritedChangeTheme({
    required Widget child,
    required this.data,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedChangeTheme oldWidget) => true;
}
