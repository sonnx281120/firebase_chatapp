import 'package:flutter/material.dart';

class NavigatorService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final currentContext = navigatorKey.currentContext;
  static final currentState = navigatorKey.currentState;

  static void navigateTo(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static void pop({Object? arguments}) {
    navigatorKey.currentState?.pop(arguments);
  }

  static void navigateAndReplace(String routeName, {Object? arguments}) {
    navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }
}
