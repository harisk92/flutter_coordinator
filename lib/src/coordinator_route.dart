import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/widgets.dart';
import 'package:uri/uri.dart';

import 'location.dart';

typedef ScreenBuilder<T> = Widget Function(BuildContext context, T location);
typedef LocationBuilder<T extends Location> = T Function(
  Map<String, String?> params,
);

class CoordinatorRoute<T extends Location> {
  String path;
  ScreenBuilder<T>? screenBuilder;
  LocationBuilder<T>? locationBuilder;
  UriParser uriParser;

  CoordinatorRoute({required this.path, this.screenBuilder, this.locationBuilder})
      : this.uriParser = UriParser(UriTemplate(path));

  Widget buildScreen(BuildContext context, T location) {
    return screenBuilder!(context, location);
  }

  Location buildLocation(String path) {
    Uri uri = Uri.parse(path);
    UriMatch match = this.uriParser.match(uri)!;
    return locationBuilder!(match.parameters);
  }

  String buildPath(Location location) =>
      uriParser.template.expand(location.params);

  bool isExactMatch(Uri uri) =>
      uriParser.matches(uri) && uriParser.match(uri)!.rest.hasEmptyPath;

  bool isExactMatchingPath(String path) => isExactMatch(Uri.parse(path));

  bool canHandleLocation(Location location) {
    print(
        "Runtime type is ${location.runtimeType.toString()} and this can handle ${T.toString()}");
    return location is T;
  }

  Type get locationType => T;
}

class CoordinatorRoutes {
  static CoordinatorRoute? findOneOfLocationType(
    List<CoordinatorRoute> routes,
    Location? location,
  ) {
    return routes.firstWhereOrNull(
      (route) => route.locationType == location.runtimeType,
    );
  }

  static CoordinatorRoute? findOneWithPath(
    List<CoordinatorRoute> routes,
    String? path,
  ) {
    return routes.firstWhereOrNull(
      (route) => route.isExactMatchingPath(path!),
    );
  }
}
