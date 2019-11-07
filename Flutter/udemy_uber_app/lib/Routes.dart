import 'package:flutter/material.dart';
import 'package:udemy_uber_app/screens/Login.dart';
import 'package:udemy_uber_app/screens/SignUp.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());

      case "/signup":
        return MaterialPageRoute(builder: (_) => SignUp());

      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Rota não encontrada !"),
        ),
        body: Center(
          child: Text("Rota não encontrada !"),
        ),
      );
    });
  }
}
