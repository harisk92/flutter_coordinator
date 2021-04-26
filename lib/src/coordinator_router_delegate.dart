import 'package:flutter/material.dart';

import 'coordinator_navigation_builder.dart';
import 'coordinator_route.dart';
import 'location.dart';

class CoordinatorRouterDelegate extends RouterDelegate<String?>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String?> {
  List<Location> _navigationStack;
  CoordinatorNavigationBuilder _navigationBuilder;
  bool _enableConfigurationReporting = true;
  WidgetBuilder? initialRouteBuilder;
  CoordinatorRouterDelegate? activeNestedDelegate;

  CoordinatorRouterDelegate? parent;
  List<CoordinatorRouterDelegate> children;
  List<CoordinatorRoute>? _routes;

  CoordinatorRouterDelegate({
    CoordinatorNavigationBuilder? navigationBuilder,
    Location? initialLocation,
    List<CoordinatorRoute>? routes,
    PageWidgetBuilder? pageBuilder,
    this.initialRouteBuilder,
  })  : this._navigationStack =
            initialLocation == null ? [] : [initialLocation],
        this._navigationBuilder = navigationBuilder ??
            DefaultNavigationBuilder(
              routes: routes,
              pageBuilder: pageBuilder ?? defaultPageBuilder,
            ),
        this._routes = routes,
        this.children = [];

  @override
  Widget build(BuildContext context) {
    if (_navigationStack.isEmpty) {
      return initialRouteBuilder != null
          ? initialRouteBuilder!(context)
          : Container();
    }

    return Navigator(
      key: navigatorKey,
      onPopPage: (route, result) {
        bool didPop = route.didPop(result);
        if (didPop) {
          _navigationStack.removeLast();
        }

        return didPop;
      },
      pages: _navigationBuilder.build(
        context,
        _navigationStack,
        currentLocation,
      ),
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  Location? get currentLocation =>
      _navigationStack.isNotEmpty && _enableConfigurationReporting
          ? _navigationStack.last
          : null;

  @override
  Future<void> setInitialRoutePath(String? configuration) {
    return _navigationStack.isEmpty
        ? Future.value()
        : super.setInitialRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String? path) async {
    CoordinatorRoute? route = CoordinatorRoutes.findOneWithPath(_routes!, path);
    if (route != null) {
      _navigationStack.add(route.buildLocation(path!));
      notifyListeners();
    }
  }

  void push(Location location) {
    _navigationStack.add(location);
    notifyListeners();
  }

  void popToRoot() {
    if (_navigationStack.isEmpty) {
      return;
    }

    _navigationStack = [_navigationStack.first];
    notifyListeners();
  }

  void pushReplacement(Location location) {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }

    _navigationStack.add(location);
    notifyListeners();
  }

  @override
  String? get currentConfiguration {
    if (currentLocation != null) {
      CoordinatorRoute? route = CoordinatorRoutes.findOneOfLocationType(
        _routes!,
        currentLocation,
      );
      return route != null ? route.buildPath(currentLocation!) : null;
    }

    return null;
  }

  set configurationReporting(bool enable) =>
      _enableConfigurationReporting = enable;
}
