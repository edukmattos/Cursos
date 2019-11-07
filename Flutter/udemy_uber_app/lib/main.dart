import 'package:flutter/material.dart';
import 'package:udemy_uber_app/Routes.dart';

import 'screens/Login.dart';

final ThemeData themeStandard = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff46e7a)
);

void main() => runApp(MaterialApp(
  title: "Uber",
  home: Login(),
  theme: themeStandard,
  initialRoute: "/",
  onGenerateRoute: Routes.generateRoutes,
  debugShowCheckedModeBanner: false,
));