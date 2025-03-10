
// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_localization;


class CleanArchLocalizationService {
  static final CleanArchLocalizationService _instance =
      CleanArchLocalizationService._internal();

  factory CleanArchLocalizationService() => _instance;

  CleanArchLocalizationService._internal();

  late SharedPreferences _prefs;
  String initialLocale = 'en'; // Varsayılan dil
  String mainLocale = "en";
  String assetsFolder = "assets/i18n";
  bool cache = true;
  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, Map<String, String>> _assetsCache = {};

  Future<void> init({
    required String initialLocale,
    required String assetsFolder,
    required String mainLocale,
    required bool cache,
  }) async {
    this.initialLocale = initialLocale;
    this.assetsFolder = assetsFolder;
    this.mainLocale = mainLocale;
    this.cache = cache;
    _prefs = await SharedPreferences.getInstance();
    await loadAssets();
  }

  final String _localeCacheKey = 'cached_locale';
  Future<CleanArchLocale> get getLocale async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(_localeCacheKey);
    return CleanArchLocale(
      locale: locale ?? mainLocale,
    );
  }

  Future<String> asyncTranslate(String key, {String? language}) async {
    String locale = language ?? (await getLocale).locale;
    if (mainLocale == locale) {
      return key;
    }

    // 1. Asset'te çeviri var mı?
    if (_assetsCache[locale] == null) {
      await _loadAssets(locale);
    }

    if (cache) {
      if (_assetsCache[locale]![key] != null) {
        return _assetsCache[locale]![key]!;
      }
      // 2. Cache'te çeviri var mı?
      String? cachedTranslation = _prefs.getString('${locale}_$key');
      if (cachedTranslation != null) {
        return cachedTranslation;
      }
    }

    // 3. Çeviri Google Translate API'den alınır
    String translatedText = await _googleTranslate(key, locale);

    // 4. Cache'e kaydedilir
    _prefs.setString('${locale}_$key', translatedText);
    return translatedText;
  }

  String syncTranslate(String key) {
    String locale = initialLocale;
    if (mainLocale == locale) {
      return key;
    }

    if (_assetsCache[locale] != null) {
      if (_assetsCache[locale]![key] != null) {
        return _assetsCache[locale]![key]!;
      }
    }

    String? cachedTranslation = _prefs.getString('${locale}_$key');
    if (cachedTranslation != null) {
      return cachedTranslation;
    }

    return key;
  }

  Future<void> loadAssets() => _loadAssets(initialLocale);
  Future<void> _loadAssets(
    String locale,
  ) async {
    try {
      String jsonString =
          await rootBundle.loadString('$assetsFolder/$locale.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _assetsCache[locale] = jsonMap.map(
        (key, value) => MapEntry(
          key,
          value.toString(),
        ),
      );
    } catch (e) {
      _assetsCache[locale] = {};
    }
  }

  Future<String> _googleTranslate(String text, String locale) async {
    final tx = await _translator.translate(
      text,
      from: mainLocale,
      to: initialLocale,
    );
    return tx.text;
  }
}
