import 'package:flutter/material.dart';
import 'package:udemy_uber_app/screens/Login.dart';
import 'package:udemy_uber_app/screens/PanelDriver.dart';
import 'package:udemy_uber_app/screens/PanelPassenger.dart';
import 'package:udemy_uber_app/screens/SignUp.dart';
import 'package:udemy_uber_app/screens/Travel.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {

    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());

      case "/signup":
        return MaterialPageRoute(builder: (_) => SignUp());

      case "/panel-passenger":
        return MaterialPageRoute(builder: (_) => PanelPassenger());

      case "/panel-driver":
        return MaterialPageRoute(builder: (_) => PanelDriver());

      case "/travel":
        return MaterialPageRoute(builder: (_) => Travel(
          args
        ));

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
