import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/home.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'model/user.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //Controladores
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  String _msgError = "";

  _checkSubmit() {
    //Recupera dados dos campos
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    //Name
    if (name.isNotEmpty && name.length > 3) {
      //Email
      if (email.isNotEmpty && email.contains("@")) {
        //Senha
        if (password.isNotEmpty && password.length >= 6) {
          setState(() {
            _msgError = "";
          });

          User user = User();
          user.name = name;
          user.email = email;
          user.password = password;

          _userSave(user);
        } else {
          setState(() {
            _msgError = "Senha obrigatória e com mínino 6 caracteres.";
          });
        }
      } else {
        setState(() {
          _msgError = "E-mail incorreto.";
        });
      }
    } else {
      setState(() {
        _msgError = "Nome obrigatório.";
      });
    }
  }

  _userSave(User user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((firebaseUser) {
      setState(() {
        //Salvar dados do usuario
        Firestore db = Firestore.instance;
        db.collection("users").document(firebaseUser.user.uid).setData(user.toMap());

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }).catchError((error) {
      print("error: " + error.toString());
      setState(() {
        _msgError = "Erro ! Verifique os campos e tente novamente.";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "images/usuario.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerName,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerEmail,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _controllerPassword,
                  obscureText: true,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    onPressed: () {
                      _checkSubmit();
                    },
                  ),
                ),
                Center(
                  child: Text(
                    _msgError,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
