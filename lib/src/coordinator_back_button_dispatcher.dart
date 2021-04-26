import 'package:flutter/widgets.dart';

import 'coordinator_router_delegate.dart';

class CoordinatorBackButtonDispatcher extends RootBackButtonDispatcher {
  CoordinatorRouterDelegate? delegate;

  CoordinatorBackButtonDispatcher({required this.delegate});

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    var canPop = await super.invokeCallback(defaultValue);
    if (!canPop) {
      canPop = await delegate!.popRoute();
    }
    return Future.value(canPop);
  }
}
