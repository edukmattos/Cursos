import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//Manuseio de Arquivos (File)
import 'dart:io';
//Converte String para json
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List _listaTarefas = [];

  _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    print("Caminho: " + diretorio.path);
    return File("${diretorio.path}/dados.json");
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();

    //Criar dados
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "Pagar Luz";
    tarefa["realizada"] = false;
    _listaTarefas.add(tarefa);

    String dados = json.encode(_listaTarefas);

    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
  }

  @override
  Widget build(BuildContext context){

    _salvarArquivo();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas tarefas"
        ),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text(
                  "Adicionar Tarefa"
                ),
                content: TextField(
                  decoration: InputDecoration(
                    labelText: "Informe a sua tarefa"
                  ),
                  onChanged: (text){
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Cancelar"
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Salvar"
                    ),
                    onPressed: (){
                      Navigator.pop(context);                        
                    },
                  )
                ],
              );
            }
          );
        }
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _listaTarefas.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(_listaTarefas[index]),
                );
              },
            ),
          )
        ],
      )
    );
  }
}