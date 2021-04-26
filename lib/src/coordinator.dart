import 'package:flutter/widgets.dart';

import 'coordinator_back_button_dispatcher.dart';
import 'coordinator_provider.dart';
import 'coordinator_route_information_parser.dart';
import 'coordinator_route_information_provider.dart';
import 'coordinator_router_delegate.dart';

class Coordinator extends StatefulWidget {
  final String? name;
  final CoordinatorRouterDelegate? routerDelegate;
  final CoordinatorRouteInformationParser? routeInformationParser;

  Coordinator({
    Key? key,
    this.name,
    this.routerDelegate,
    this.routeInformationParser,
  }) : super(key: key);

  static CoordinatorRouterDelegate of(BuildContext context) {
    try {
      return Router.of(context).routerDelegate as CoordinatorRouterDelegate;
    } catch (e) {
      return CoordinatorProvider.of(context)!.routerDelegate;
    }
  }

  @override
  _CoordinatorState createState() => _CoordinatorState();
}

class _CoordinatorState extends State<Coordinator> {
  GlobalKey _routerKey = GlobalKey();
  CoordinatorRouterDelegate? get routerDelegate => widget.routerDelegate;
  CoordinatorBackButtonDispatcher get backButtonDispatcher =>
      CoordinatorBackButtonDispatcher(delegate: routerDelegate);

  @override
  void initState() {
    super.initState();
    routerDelegate!.configurationReporting = false;
  }

  @override
  void deactivate() {
    super.deactivate();
    print("Invisible");
  }

  @override
  Widget build(BuildContext context) {
    final parentRouteInformationProvider =
        Router.of(context).routeInformationProvider;
    final parentDelegate =
        Router.of(context).routerDelegate as CoordinatorRouterDelegate;
    parentDelegate.activeNestedDelegate = routerDelegate;
    routerDelegate!.parent = parentDelegate;

    return Router(
      key: _routerKey,
      routerDelegate: routerDelegate!,
      routeInformationParser: CoordinatorRouteInformationParser(),
      routeInformationProvider: ChildCoordinatorRouteInformationProvider(
          parent: parentRouteInformationProvider),
      backButtonDispatcher: backButtonDispatcher,
    );
  }
}
