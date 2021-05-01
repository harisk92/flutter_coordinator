import 'package:flutter/widgets.dart';

class CoordinatorRouteInformationParser
    extends RouteInformationParser<String?> {
  @override
  Future<String?> parseRouteInformation(RouteInformation information) async =>
      information.location;

  @override
  RouteInformation restoreRouteInformation(String? path) =>
      RouteInformation(location: path);
}
