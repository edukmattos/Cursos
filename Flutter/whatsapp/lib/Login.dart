import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'package:whatsapp/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'model/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Controladores
  TextEditingController _controllerEmail = TextEditingController(text: "edukmattos@gmail.com");
  TextEditingController _controllerPassword = TextEditingController(text: "1234567");

  String _msgError = "";

  _checkSubmit() {
    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      //Senha
      if (password.isNotEmpty) {
        setState(() {
          _msgError = "";
        });

        User user = User();
        user.email = email;
        user.password = password;

        _userLogin(user);
      } else {
        setState(() {
          _msgError = "Senha obrigatória.";
        });
      }
    } else {
      setState(() {
        _msgError = "E-mail obrigatório/incorreto.";
      });
    }
  }

  _userLogin(User user) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      setState(() {

        Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_HOME);
        
      });
    }).catchError((error) {
      print("error: " + error.toString());
      setState(() {
        _msgError = "Erro ! Verifique os campos e tente novamente.";
      });
    });
  }

  Future _checkUserIsLogged() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    FirebaseUser userLogged = await auth.currentUser();

    if (userLogged != null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_HOME);
    }
  }

  @override
  void initState() {
    _checkUserIsLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerEmail,
                    autofocus: true,
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
                      "Entrar",
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
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta ? Cadastre-se aqui !",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _msgError,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
