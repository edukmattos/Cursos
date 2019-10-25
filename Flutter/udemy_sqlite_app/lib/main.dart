import 'package:flutter/material.dart';
import 'package:udemy_sqlite_app/home.dart';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;

void main(){
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    )
  );
}