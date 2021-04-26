import 'package:flutter/cupertino.dart';

class ChildCoordinatorRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  RouteInformationProvider? parent;

  ChildCoordinatorRouteInformationProvider({this.parent});

  @override
  void addListener(listener) {
    print("Adding child listener");
    parent!.addListener(listener);
  }

  @override
  void removeListener(listener) {
    print("Remove child listener");
    parent!.removeListener(listener);
  }

  @override
  void routerReportsNewRouteInformation(RouteInformation routeInformation) {
    print("Reporting ${routeInformation.location}");
    parent!.routerReportsNewRouteInformation(routeInformation);
    notifyListeners();
  }

  @override
  RouteInformation? get value => parent!.value;
}
