import 'package:flutter/material.dart';
import 'package:whatsapp/Login.dart';
import 'package:flutter/widgets.dart';

void main(){
  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xff0754E54),
      accentColor: Color(0xff25D366),
    ),
    debugShowCheckedModeBanner: false,
  ));
}