import 'package:flutter/cupertino.dart';

class CleanArchTabsRouter extends StatefulWidget {
  const CleanArchTabsRouter({
    super.key,
    required this.childs,
    required this.tabIndex,
    required this.onChanged,
  });
  final List<Widget> childs;

  final int tabIndex;
  final ValueChanged<GlobalKey<NavigatorState>> onChanged;
  @override
  State<CleanArchTabsRouter> createState() => _VisoxTabsRouterState();
}

class _VisoxTabsRouterState extends State<CleanArchTabsRouter> {
  late List<GlobalKey<NavigatorState>> navigators;

  @override
  void initState() {
    loadKeys();
    super.initState();
  }

  void loadKeys() {
    navigators = [];

    for (var element in widget.childs) {
      navigators.add(
        GlobalKey<NavigatorState>(
          debugLabel: "${element.key.hashCode.toString()}/Navigators",
        ),
      );
    }
    widget.onChanged(navigators[widget.tabIndex]);
  }

  @override
  void didUpdateWidget(covariant CleanArchTabsRouter oldWidget) {
    if (widget.tabIndex != oldWidget.tabIndex) {
      widget.onChanged(navigators[widget.tabIndex]);
      if (mounted) {
        setState(() {});
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.tabIndex,
      children: [
        for (int index = 0; index < navigators.length; index++)
          Offstage(
            offstage: widget.tabIndex == index ? false : true,
            child: TabNavigator(
              navigatorKey: navigators[index],
              child: widget.childs[index],
            ),
          ),
      ],
    );
  }
}

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  const TabNavigator({
    super.key,
    required this.child,
    required this.navigatorKey,
  });
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          CupertinoPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          )
        ];
      },
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => child};
  }
}