import 'package:flutter/material.dart';
import 'dart:math';

void main(){
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  var _frases = [
    "De nada adianta ter sonhos, se você não se empenhar em correr atrás.",
    "Positividade para começar o dia é colocar a sua fé em prática.",
    "Toda manhã você tem duas escolhas: continuar dormindo com seus sonhos ou acordar e persegui-los!",
    "A cada novo dia, a cada momento, temos a nossa disposição a maravilhosa possibilidade do encontro, que traz em si infinitas oportunidades. Precisamos apenas estar atentos.",
    "Preste atenção nas oportunidades que estão à sua frente!"
  ];

  var _fraseGerada = "Clique aqui para gerar uma nova frase";

  void _gerarFrase(){

    var nrSorteado = Random().nextInt(_frases.length);

    setState(() {
      _fraseGerada = _frases[nrSorteado];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Frases do dia"
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          /*: BoxDecoration(
              border: Border.all(
                  width:3,
                  color: Colors.amber
              )
          ),*/
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/frases-bom-dia.jpg"),
              Text(
                  _fraseGerada,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      color: Colors.black
                  )
              ),
              RaisedButton(
                child: Text(
                    "Nova Frase",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    )
                ),
                color: Colors.green,
                onPressed: _gerarFrase,
              )
            ],
          ),
        )
      )
    );
  }
}
