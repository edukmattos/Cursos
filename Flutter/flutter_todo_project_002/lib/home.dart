import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List _listaTarefas = [
    "Pagar energia eletrica",
    "Estudar para Prova Matematica",
    "Comprar banana"
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas tarefas"
        ),
        backgroundColor: Colors.purple,
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
      ),
    );
  }
}