import 'package:flutter/material.dart';
import 'package:gasolina_alcool_app/CampoTexto.dart';

void main(){
  runApp(
    MaterialApp(
      home: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CampoTexto(),
      ),
    )
  );
}