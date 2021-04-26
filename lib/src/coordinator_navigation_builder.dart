import 'package:flutter/material.dart';

import 'coordinator_route.dart';
import 'location.dart';

abstract class CoordinatorNavigationBuilder {
  List<Page<dynamic>> build(
      BuildContext context, List<Location> history, Location? currentLocation);
}

typedef PageWidgetBuilder = Page<dynamic> Function(
    BuildContext context, Location location, Widget child);

final defaultPageBuilder =
    (BuildContext context, Location location, Widget child) => MaterialPage(
          key: ValueKey(location.uniqueKey),
          child: child,
        );

class DefaultNavigationBuilder extends CoordinatorNavigationBuilder {
  List<CoordinatorRoute>? routes;
  PageWidgetBuilder? pageBuilder;

  DefaultNavigationBuilder({
    List<CoordinatorRoute>? this.routes,
    this.pageBuilder,
  });

  @override
  List<Page> build(
    BuildContext context,
    List<Location> history,
    Location? currentLocation,
  ) {
    return history.map((location) {
      final route = CoordinatorRoutes.findOneOfLocationType(routes!, location);

      Widget? child;
      if (route != null) {
        child = route.buildScreen(context, location);
      }
      return pageBuilder!(context, location, child ?? Container());
    }).toList();
  }
}
