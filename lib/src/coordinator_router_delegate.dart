import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'coordinator_navigation_builder.dart';
import 'coordinator_route.dart';
import 'location.dart';
import 'optional.dart';

abstract class CoordinatorRouter {
  void pop([dynamic result]);
  void popToRoot();
  Future<dynamic?> push(Location location);
  void pushReplacement(Location location);
  void pushNewRoot(Location location);
}

class CoordinatorRouterDelegate extends RouterDelegate<Optional<String>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Optional<String>>
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

    print(navigationStack);
    return Navigator(
      key: navigatorKey,
      transitionDelegate: transitionDelegate,
      reportsRouteUpdateToEngine: reportsRouteUpdateToEngine,
      observers: observers,
      restorationScopeId: restorationScopeId,
      onPopPage: (route, result) {
        bool didPop = route.didPop(result);
        print(result);
        if (didPop) {
          final last = navigationStack.removeLast();
          last.result.complete(result);
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

  NavigatorState? get navigatorState => key.currentState;

  @override
  Future<void> setInitialRoutePath(Optional<String> configuration) {
    return navigationStack.isEmpty
        ? Future.value()
        : super.setInitialRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(Optional<String> path) async {
    CoordinatorRoute? route =
        CoordinatorRoutes.findOneWithPath(routes, path.data);
    if (route == null) return;

    final pathString = path.data;
    if (pathString == null) return;

    navigationStack.add(route.buildLocation(pathString));
    notifyListeners();
  }

  @override
  Future<dynamic?> push(Location location) async {
    navigationStack.add(location);
    notifyListeners();
    return location.result.future;
  }

  void pop([dynamic result]) {
    navigatorState?.pop(result);
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

  void pushNewRoot(Location location) {
    navigationStack = [location];
    notifyListeners();
  }

  @override
  Optional<String> get currentConfiguration {
    final currentLocation = this.currentLocation;
    if (currentLocation == null) return Optional();

    CoordinatorRoute? route = CoordinatorRoutes.findOneOfLocationType(
      routes,
      currentLocation,
    );

    return Optional(data: route?.buildPath(currentLocation));
  }
}
