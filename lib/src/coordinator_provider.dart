import 'package:flutter/widgets.dart';

import 'coordinator_router_delegate.dart';

typedef CoordinatorWidgetBuilder = Widget Function(
    CoordinatorRouterDelegate routerDelegate);

class CoordinatorProvider extends InheritedWidget {
  CoordinatorProvider({
    Key? key,
    required this.routerDelegate,
    required CoordinatorWidgetBuilder builder,
  }) : super(key: key, child: builder(routerDelegate));

  final CoordinatorRouterDelegate routerDelegate;

  static CoordinatorProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CoordinatorProvider>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
