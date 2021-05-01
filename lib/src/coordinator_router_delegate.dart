import 'package:flutter/material.dart';

import 'coordinator_navigation_builder.dart';
import 'coordinator_route.dart';
import 'location.dart';

abstract class CoordinatorRouter {
  void push(Location location);
  void popToRoot();
  void pushReplacement(Location location);
}

class CoordinatorRouterDelegate extends RouterDelegate<String?>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String?>
    implements CoordinatorRouter {
  List<Location> navigationStack;
  CoordinatorNavigationBuilder navigationBuilder;
  WidgetBuilder? initialRouteBuilder;

  CoordinatorRouterDelegate? parent;
  List<CoordinatorRouterDelegate> children;
  List<CoordinatorRoute> routes;
  GlobalKey<NavigatorState> key;

  TransitionDelegate<dynamic> transitionDelegate;
  bool reportsRouteUpdateToEngine;
  List<NavigatorObserver> observers;
  String? restorationScopeId;

  CoordinatorRouterDelegate({
    Location? initialLocation,
    required List<CoordinatorRoute> routes,
    CoordinatorNavigationBuilder? navigationBuilder,
    PageWidgetBuilder? pageBuilder,
    this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
    this.observers = const <NavigatorObserver>[],
    this.reportsRouteUpdateToEngine = false,
    this.initialRouteBuilder,
    this.restorationScopeId,
  })  : this.navigationStack = initialLocation == null ? [] : [initialLocation],
        this.navigationBuilder = navigationBuilder ??
            DefaultNavigationBuilder(
              routes: routes,
              pageBuilder: pageBuilder ?? defaultPageBuilder,
            ),
        this.routes = routes,
        this.key = GlobalKey<NavigatorState>(),
        this.children = [];

  @override
  Widget build(BuildContext context) {
    if (navigationStack.isEmpty) {
      return initialRouteBuilder?.call(context) ?? Container();
    }

    return Navigator(
      key: navigatorKey,
      transitionDelegate: transitionDelegate,
      reportsRouteUpdateToEngine: reportsRouteUpdateToEngine,
      observers: observers,
      restorationScopeId: restorationScopeId,
      onPopPage: (route, result) {
        bool didPop = route.didPop(result);
        if (didPop) {
          navigationStack.removeLast();
        }

        return didPop;
      },
      pages: navigationBuilder.build(
        context,
        navigationStack,
        currentLocation,
      ),
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => key;

  Location? get currentLocation =>
      navigationStack.isNotEmpty ? navigationStack.last : null;

  @override
  Future<void> setInitialRoutePath(String? configuration) {
    return navigationStack.isEmpty
        ? Future.value()
        : super.setInitialRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String? path) async {
    CoordinatorRoute? route = CoordinatorRoutes.findOneWithPath(routes, path);
    if (route == null) return;

    navigationStack.add(route.buildLocation(path!));
    notifyListeners();
  }

  @override
  void push(Location location) {
    navigationStack.add(location);
    notifyListeners();
  }

  @override
  void popToRoot() {
    if (navigationStack.isEmpty) return;
    navigationStack = [navigationStack.first];
    notifyListeners();
  }

  @override
  void pushReplacement(Location location) {
    if (navigationStack.isNotEmpty) navigationStack.removeLast();
    navigationStack.add(location);
    notifyListeners();
  }

  @override
  String? get currentConfiguration {
    final currentLocation = this.currentLocation;
    if (currentLocation == null) return null;

    CoordinatorRoute? route = CoordinatorRoutes.findOneOfLocationType(
      routes,
      currentLocation,
    );

    return route?.buildPath(currentLocation);
  }
}
