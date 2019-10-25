import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FloatingActionButton"),
      ),
      body: Text("Conteúdo"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: Icon(Icons.shopping_cart),
        label: Text("Adicionar"),
        /*
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0)
        ),
        mini: false,
        child: Icon(Icons.add),
        onPressed: (){
          print("Botão pressionado !");
        },
        */
      ),
      bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.menu),
            )
          ],
        ),
      ),
    );
  }
}
