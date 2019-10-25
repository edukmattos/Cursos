import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = ["Supermercado", "Estudar", "Pagar Luz"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Tarefas"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _listaTarefas[index]
                    )
                  );
                }
            )
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat ,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text("Incluir Tarefa"),
                content: TextFormField(
                  decoration: InputDecoration(),
                )
              );
            }
          );
        },
      ),
    );
  }
}
