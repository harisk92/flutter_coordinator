import 'package:coordinator/coordinator.dart';
import 'package:coordinator/src/coordinator_route_information_provider.dart';
import 'package:flutter/widgets.dart';

import 'coordinator_back_button_dispatcher.dart';
import 'coordinator_router_delegate.dart';

class Coordinator extends StatefulWidget {
  final String? name;
  final CoordinatorRouterDelegate routerDelegate;

  Coordinator({
    Key? key,
    this.name,
    required Location initialLocation,
    required List<CoordinatorRoute> routes,
    CoordinatorNavigationBuilder? navigationBuilder,
  })  : this.routerDelegate = CoordinatorRouterDelegate(
          initialLocation: initialLocation,
          routes: routes,
          navigationBuilder: navigationBuilder,
        ),
        super(key: key);

  static CoordinatorRouter of(BuildContext context) {
    try {
      return Router.of(context).routerDelegate as CoordinatorRouter;
    } catch (e) {
      throw Exception("Can't find appropriate router delegate");
    }
  }

  @override
  _CoordinatorState createState() => _CoordinatorState();
}

class _CoordinatorState extends State<Coordinator> {
  CoordinatorRouterDelegate get routerDelegate => widget.routerDelegate;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    print("Invisible");
  }

  @override
  Widget build(BuildContext context) {
    return CoordinatorRoot(
      routerDelegate: routerDelegate,
      builder: (context, routerDelegate) => Router(
        routerDelegate: routerDelegate,
        routeInformationParser: CoordinatorRouteInformationParser(),
        routeInformationProvider: ChildCoordinatorRouteInformationProvider(),
        backButtonDispatcher: CoordinatorBackButtonDispatcher(
          delegate: routerDelegate,
        ),
      ),
    );
  }
}
