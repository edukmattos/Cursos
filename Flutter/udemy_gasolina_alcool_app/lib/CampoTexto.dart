import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Entrada de dados"
        )
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite um valor"
              ),
              enabled: true,
              maxLength: 5,
              maxLengthEnforced: true,
              style: TextStyle(
                fontSize: 25,
                color: Colors.green
              ),
              obscureText: false,
              /*
              onChanged: (String texto){
                print("Valor digitado: " + texto);
              },
              */
              onSubmitted: (String texto){
                print("Valor digitado: " + texto);
              },
              controller: _textEditingController,
            ),
          ),
          RaisedButton(
            child: Text(
                "Salvar",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
                color: Colors.lightGreen,
                onPressed: (){
                  print("Valor digitado: " + _textEditingController.text);
                },
            )
        ],
      )
    );
  }
}
