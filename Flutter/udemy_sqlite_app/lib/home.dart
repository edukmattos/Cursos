import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente) {
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER )";
        db.execute(sql);
      }
    );
    return bd;
    //print("aberto: " + bd.isOpen.toString());
  }

  _salvar() async {
    Database.db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Eduardo Mattos",
      "idade": 49
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Savo id: $id");
  }

  @override
  Widget build(BuildContext context) {

    _salvar();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas Tarefas"
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
