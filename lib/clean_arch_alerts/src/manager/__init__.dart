// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_alerts;

class CleanArchAlerts {
  static Future<void> show({
    required String title,
    SnackyType type = SnackyType.info,
    String? subtitle,
    Widget Function(BuildContext, CancelableSnacky)? leadingWidgetBuilder,
    Widget Function(BuildContext, CancelableSnacky)? trailingWidgetBuilder,
    Widget Function(BuildContext, CancelableSnacky)? bottomWidgetBuilder,
    VoidCallback? onTap,
    bool canBeClosed = false,
    bool openUntillClosed = false,
    Duration? showDuration,
    Duration transitionDuration = const Duration(milliseconds: 250),
    Curve transitionCurve = Curves.easeInOut,
    SnackyLocation? location,
  }) async {
    final snacky = Snacky(
      title: title,
      type:
          type, // or SnackyType.error, SnackyType.success, SnackyType.warning, SnackyType.info
      showDuration: showDuration, // How long the snacky should be shown
      transitionDuration:
          transitionDuration, // How long the transition should take
      transitionCurve: transitionCurve, // The curve of the transition
      location:
          location, // Where the snacky should be shown (SnackyLocation.top or SnackyLocation.bottom)
      openUntillClosed:
          openUntillClosed, // If the snacky should be open untill closed or canceled
      canBeClosed:
          canBeClosed, // If the snacky can be closed by the user (X button)
      onTap: () => onTap, // What should happen when the snacky is tapped
      subtitle: subtitle, // The subtitle of the snacky
      leadingWidgetBuilder:
          leadingWidgetBuilder, // A widget that should be shown before the title
      trailingWidgetBuilder:
          trailingWidgetBuilder, // A widget that should be shown after the title
    );
    SnackyController.instance.showMessage(
      (context) => snacky,
    );
  }
  
  static Future<void> close() async {
    SnackyController.instance.cancelAll();
  }
}
