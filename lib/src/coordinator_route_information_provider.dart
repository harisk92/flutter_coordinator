import 'package:flutter/cupertino.dart';

class ChildCoordinatorRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  RouteInformationProvider? parent;

  ChildCoordinatorRouteInformationProvider({this.parent}) {
    //print("Child router provider ${parent?.value?.location}");
  }

  @override
  void addListener(listener) {
    //parent?.addListener(listener);
    print("Adding child listener");
    //super.addListener(listener);
  }

  @override
  void removeListener(listener) {
    //print("Remove child listener");
    //super.removeListener(listener);
    parent?.removeListener(listener);
  }

  @override
  void routerReportsNewRouteInformation(RouteInformation routeInformation) {
    //print("Reporting ${routeInformation.location}");
    //parent?.routerReportsNewRouteInformation(routeInformation);
    //notifyListeners();
  }

  @override
  // TODO: implement value
  RouteInformation? get value => parent?.value;
}
