import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerAlcool = TextEditingController();
  TextEditingController _controllerGasolina = TextEditingController();
  String _textoResultado = "";

  void _calcular(){
    double precoAlcool = double.tryParse(_controllerAlcool.text);
    double precoGasolina = double.tryParse(_controllerGasolina.text);

    if(precoAlcool==null || precoGasolina==null){
      setState(() {
        _textoResultado = "Valor inválido ! Informar valor maior que ZERO utilizando o ponto (.)";
      });
    }else{
      if((precoAlcool/precoGasolina) >= 0.7){
        setState(() {
          _textoResultado = "Melhor abastecer com Gasolina !";
        });
      }else{
        setState(() {
          _textoResultado = "Melhor abastecer com Álcool !";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Álcool ou Gasolina"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 32),
                child: Image.asset("images/logo.png"),
                ),
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 10),
                child: Text(
                  "Saiba qual a melhor oçãp de abastecimento para o seu carro.",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                      ),
                  ),
                ),
              TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Preço Álcool",
                    hintText: "ex.: 1.59",
                    ),
                style: TextStyle(
                    fontSize: 22
                    ),
                controller: _controllerAlcool,
                ),
              TextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Preço Gasolina",
                    hintText: "ex.: 3.59",
                    ),
                style: TextStyle(
                    fontSize: 22
                    ),
                controller: _controllerGasolina,
                ),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 10),
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Text(
                      "Calcular",
                      style: TextStyle(
                          fontSize: 20
                          )
                      ),
                  onPressed: _calcular,
                  ),
                ),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 20),
                child: Text(
                  _textoResultado,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                      ),
                  ),
                )
            ],
            ),
        )
      ),
    );
  }
}
