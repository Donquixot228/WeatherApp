import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:weather/pages/search_page/view/search_page.dart';

import '../pages/pages.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    log('This is route : ${settings.name}');
    switch (settings.name) {
      case HomePage.routeName:
        return _FadeRoute(child: HomePage.create(), time: 0);
      case SearchPage.routeName:
        return _FadeRoute(child: SearchPage.create(), time: 0);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
      ),
    );
  }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final int time;

  _FadeRoute({
    required this.child,
    required this.time,
  }) : super(
      pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          ) =>
      child,
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) =>
          FadeTransition(
            opacity: animation,
            child: child,
          ),
      transitionDuration: Duration(milliseconds: time));
}
