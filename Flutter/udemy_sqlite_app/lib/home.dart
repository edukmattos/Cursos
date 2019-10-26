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
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Sandra Mattos",
      "idade": 23
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo id: $id");
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();

    String sql = "SELECT * FROM usuarios";
    List usuarios = await bd.rawQuery(sql);

    for (var usuario in usuarios) {
      print(
        "item id: " + usuario['id'].toString() +
          " nome: " + usuario['nome'] +
          " idade: " + usuario['idade'].toString()
      );
    }

    //print("Usuarios: " + usuarios.toString());
  }

  _recuperarUsuarioPeloId(int id) async {
    Database bd = await _recuperarBancoDados();

    List usuarios = await bd.query(
      "usuarios",
      columns: [
        "id",
        "nome",
        "idade"
      ],
      where: "id = ?",
      whereArgs: [id]
    );

    for (var usuario in usuarios) {
      print(
        "item id: " + usuario['id'].toString() +
          " nome: " + usuario['nome'] +
          " idade: " + usuario['idade'].toString()
      );
    }
  }

  _excluirUsuarioPeloId(int id) async {
    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete(
      "usuarios",
      where: "id = ?",
      whereArgs: [id]
    );
  }

  @override
  Widget build(BuildContext context) {

    _excluirUsuarioPeloId(3);
    _listarUsuarios();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Usuários"
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
