import 'package:flutter/material.dart';

class AppRouteObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) {
      // Do not allow popping from any route
      return;
    }
    super.didPop(route, previousRoute);
  }
}
