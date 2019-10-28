import 'package:flutter/material.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/Messages.dart';
import 'package:whatsapp/Profile.dart';
import 'package:whatsapp/Signup.dart';
import 'package:whatsapp/home.dart';

class RouteGenerator {

  static const String ROUTE_ROOT = "/";
  static const String ROUTE_HOME = "/home";
  static const String ROUTE_SIGNUP = "/signup";
  static const String ROUTE_SIGNIN = "/login";
  static const String ROUTE_PROFILE = "/profile";
  static const String ROUTE_MESSAGES = "/messages";

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case ROUTE_ROOT:
        return MaterialPageRoute(builder: (_) => Login());
      case ROUTE_HOME:
        return MaterialPageRoute(builder: (_) => Home());
      case ROUTE_SIGNUP:
        return MaterialPageRoute(builder: (_) => Signup());
      case ROUTE_SIGNIN:
        return MaterialPageRoute(builder: (_) => Login());
      case ROUTE_PROFILE:
        return MaterialPageRoute(builder: (_) => Profile());
      case ROUTE_MESSAGES:
        return MaterialPageRoute(builder: (_) => Messages(args));

      default:
        _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Tela não encontrada !",
            ),
          ),
          body: Center(
            child: Text("Tela não encontrada"),
          )
        );
      }
    );
  }
}
