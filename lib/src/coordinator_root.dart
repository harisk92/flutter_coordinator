import 'package:flutter/widgets.dart';

import 'coordinator_router_delegate.dart';

typedef CoordinatorWidgetBuilder = Widget Function(
  BuildContext context,
  CoordinatorRouterDelegate routerDelegate,
);

/*
  CoordinatorRoot is used to keep state of CoordinatorRouterDelegate in case of rebuilds.
 */
class CoordinatorRoot extends StatefulWidget {
  final CoordinatorRouterDelegate routerDelegate;
  final CoordinatorWidgetBuilder builder;

  const CoordinatorRoot({
    Key? key,
    required this.routerDelegate,
    required this.builder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CoordinatorRootState();
}

class _CoordinatorRootState extends State<CoordinatorRoot> {
  late CoordinatorRouterDelegate routerDelegate;

  @override
  void initState() {
    super.initState();
    routerDelegate = widget.routerDelegate;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, routerDelegate);
  }
}
