// ignore: use_string_in_part_of_directives
part of clean_arch_router;

class CleanArchRoute {
  final Widget mobile;
  final String path;
  final Widget? webOrDesktop;
  final Widget? tablet;
  final TransitionType transitionType;
  final Future<bool> Function()? routeGuard;
  final List<Future<bool> Function()>? multipleRouteGuard;

  const CleanArchRoute({
    required this.mobile,
    this.webOrDesktop,
    this.tablet,
    required this.path,
    this.transitionType = TransitionType.native,
    this.routeGuard,
    this.multipleRouteGuard,
  });
}

class CleanArchRouter {
  static final CleanArchRouter _instance = CleanArchRouter._internal();
  factory CleanArchRouter() => _instance;
  CleanArchRouter._internal();

  final GlobalKey<NavigatorState> initialKey = GlobalKey<NavigatorState>();

  Future<bool> _guard(CleanArchRoute route) async {
    if (route.routeGuard != null) {
      return await route.routeGuard!();
    }
    return true;
  }

  void navigate([GlobalKey<NavigatorState>? key, String? path]) {
    (key ?? initialKey).currentState?.popUntil(
          (route) => route.settings.name == (path ?? '/'),
        );
  }

  Future<T?> pushTransparentRoute<T>(
    Widget page, {
    Color backgroundColor = Colors.transparent,
    Duration transitionDuration = const Duration(milliseconds: 200),
    Duration reverseTransitionDuration = const Duration(milliseconds: 200),
    bool rootNavigator = false,
  }) {
    return Navigator.of(initialKey.currentState!.context,
            rootNavigator: rootNavigator)
        .push(
      TransparentRoute(
        builder: (_) => page,
        backgroundColor: backgroundColor,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
      ),
    );
  }

  bool canPop([GlobalKey<NavigatorState>? key]) {
    return (key ?? initialKey).currentState?.canPop() ?? false;
  }

  Future<bool> _checkRouteGuards(CleanArchRoute route) async {
    for (var element in route.multipleRouteGuard ?? []) {
      if (!(await element())) {
        return false;
      }
    }
    return true;
  }

  bool isNull(GlobalKey<NavigatorState>? key) {
    if (key == null) {
      CleanArchLog.instance.logError(
        CleanArchException(
            "Please provide a global key to run application context!"),
      );
      return true;
    }
    return false;
  }

  Widget platformType(CleanArchRoute page) {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return page.webOrDesktop ?? page.mobile;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      final firstDevice = ui.PlatformDispatcher.instance.views.first;
      final windowWidth =
          firstDevice.physicalSize.width / firstDevice.devicePixelRatio;

      if (windowWidth > 600) {
        return page.tablet ?? page.mobile;
      } else {
        return page.mobile;
      }
    }
    return page.mobile;
  }

  void go(CleanArchRoute page, {GlobalKey<NavigatorState>? key}) async {
    if (isNull(key ?? initialKey) ||
        !(await _guard(page)) ||
        !(await _checkRouteGuards(page))) {
      throw Exception();
    }
    (key ?? initialKey).currentState!.pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => platformType(page),
            settings: RouteSettings(name: page.path),
          ),
          (route) => false,
        );
  }

  void modalPopNamed<T extends Object?>({
    required String modalName,
    GlobalKey<NavigatorState>? key,
  }) {
    if (isNull(key ?? initialKey)) throw Exception();
    (key ?? initialKey).currentState!.popUntil(ModalRoute.withName(modalName));
  }

  void pop<T extends Object?>({T? result, GlobalKey<NavigatorState>? key}) {
    if (isNull(key ?? initialKey)) throw Exception();
    (key ?? initialKey).currentState!.pop(result);
  }

  Future<T?> push<T>(CleanArchRoute page,
      {bool? opaque, GlobalKey<NavigatorState>? key}) async {
    if (isNull(key ?? initialKey) ||
        !(await _guard(page)) ||
        !(await _checkRouteGuards(page))) {
      throw Exception();
    }

    if (opaque != null && !opaque) {
      return (key ?? initialKey).currentState!.push(
            PageRouteBuilder(
              opaque: opaque,
              settings: RouteSettings(name: page.path),
              pageBuilder: (context, _, __) => platformType(page),
            ),
          );
    }
    return (key ?? initialKey).currentState!.push(
          CupertinoPageRoute(
            builder: (context) => platformType(page),
            settings: RouteSettings(name: page.path),
          ),
        );
  }

  Future<T?> modalPush<T>(
    Widget page, {
    GlobalKey<NavigatorState>? key,
    Color? barrierColor,
    required String pathName,
  }) async {
    return showCupertinoModalPopup(
      routeSettings: RouteSettings(name: pathName),
      context: (key ?? initialKey).currentContext!,
      barrierColor: barrierColor ?? kCupertinoModalBarrierColor,
      builder: (context) => page,
    );
  }

  Future<T?> dialogPush<T>(Widget page,
      {bool barrierDismissible = true, GlobalKey<NavigatorState>? key}) async {
    return showCupertinoDialog(
      context: (key ?? initialKey).currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (context) => page,
    );
  }
}
