import 'package:flutter/widgets.dart';

import 'optional.dart';

class CoordinatorRouteInformationParser
    extends RouteInformationParser<Optional<String>> {
  @override
  Future<Optional<String>> parseRouteInformation(
          RouteInformation information) async =>
      Optional(data: information.location);

  @override
  RouteInformation restoreRouteInformation(Optional<String> path) =>
      RouteInformation(location: path.data);
}
