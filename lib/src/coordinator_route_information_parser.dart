import 'package:flutter/widgets.dart';

class CoordinatorRouteInformationParser extends RouteInformationParser<String?> {
  @override
  Future<String?> parseRouteInformation(
      RouteInformation routeInformation) async {
    print(routeInformation.location);
    return routeInformation.location;
  }

  @override
  RouteInformation restoreRouteInformation(String? path) {
    print("Restoring ${path}");
    return RouteInformation(location: path);
  }
}
