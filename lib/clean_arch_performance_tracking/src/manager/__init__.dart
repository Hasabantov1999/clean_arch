// ignore: use_string_in_part_of_directives
part of clean_arch_performance_tracking;

class PerformanceNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final startTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final duration = DateTime.now().difference(startTime);

        if (duration.inMilliseconds > 100) {
          CA.logger.logChat(
            '📄 ${route.settings.name ?? "Unknown Route"} yükleme süresi: ${duration.inMilliseconds}ms (Sayfayı Performans Konusunda Optimize Edin!)',
          );
        } else {
          CA.logger.logChat(
            '📄 ${route.settings.name ?? "Unknown Route"} yükleme süresi: ${duration.inMilliseconds}ms',
          );
        }
      },
    );
  }
}
