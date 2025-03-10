// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_injector;

class CleanArchInjector {
  static final Map<Type, dynamic> _instances = HashMap<Type, dynamic>();

  static void init<T>(T instance) {
    _instances[T] = instance;
  }

  static T getInstance<T>() {
    if (!_instances.containsKey(T)) {
      throw Exception("❌ CleanArchInjector: ${T.toString()} bulunamadı! "
          "Önce `init()` ile başlatmalısın.");
    }
    return _instances[T] as T;
  }

  static T getProvider<T>({
    required T http,
    required T mock,
  }) {
    if (CleanArchConfig.get("DATA-TYPE") == "mock") {
      return mock;
    } else {
      return http;
    }
  }

  static void dispose<T>() {
    if (_instances.containsKey(T)) {
      var instance = _instances[T];

      if (instance is CleanArchDisposable) {
        instance.dispose();
      }

      _instances.remove(T);
    }
  }

  static void clearAllInstances() {
    _instances.forEach((key, instance) {
      if (instance is CleanArchDisposable) {
        instance.dispose();
      }
    });
    _instances.clear();
  }
}

mixin CleanArchDisposable {
  void dispose();
}
