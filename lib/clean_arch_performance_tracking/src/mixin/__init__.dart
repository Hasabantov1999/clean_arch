// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_performance_tracking;

mixin PerformanceTracker on Widget {
  Widget buildWithPerformanceTracking(
      BuildContext context, Widget Function(BuildContext) builder) {
    final startTime = DateTime.now();
    final widget = builder(context);
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);

    if (duration.inMilliseconds > 16) {
      CA.logger.logChat(
        '⚠️ $runtimeType build süresi uzun: ${duration.inMilliseconds}ms',
      );
    } else {
      CA.logger.logChat(
        '✅ $runtimeType performansı iyi: ${duration.inMilliseconds}ms',
      );
    }

    return widget;
  }
}
