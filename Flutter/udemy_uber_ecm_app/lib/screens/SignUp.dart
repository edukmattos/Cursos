import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udemy_uber_app/model/User.dart';
import 'package:udemy_uber_app/screens/Login.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _controllerName = TextEditingController(text: "Eduardo Mattos");
  TextEditingController _controllerEmail = TextEditingController(text: "edukmattos@gmail.com");
  TextEditingController _controllerPassword = TextEditingController(text: "secret");
  TextEditingController _controllerPasswordRepeat = TextEditingController(text: "secret");
  bool _userType = false;
  String _errorMsg = "";
  String _errorCode = "";

  _formValidation() {
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    String passwordRepeat = _controllerPasswordRepeat.text;

    if (name.isNotEmpty) {
      if (email.isNotEmpty) {
        if (email.contains("@")) {
          if (password.isNotEmpty) {
            if (password.length >= 6) {
              if (passwordRepeat.isNotEmpty){
                if (password == passwordRepeat){
                  User user = User();

                  user.userName = name;
                  user.userEmail = email;
                  user.userPassword = password;
                  user.userType = user.userTypeCheck(_userType);

                  _userSave(user);
                }else{
                  setState(() {
                    _errorMsg = "Senhas diferentes";
                  });
                }

              }else{
                setState(() {
                  _errorMsg = "Confirme Senha";
                });
              }
            }else{
              setState(() {
                _errorMsg = "Mínimo 6 caracteres";
              });
            }
          } else {
            setState(() {
              _errorMsg = "Preencha Senha";
            });
          }
        } else {
          setState(() {
            _errorMsg = "E-Mail incorreto";
          });
        }
      } else {
        setState(() {
          _errorMsg = "Preencha o E-Mail";
        });
      }
    } else {
      setState(() {
        _errorMsg = "Preencha o Nome";
      });
    }
  }

  _userSave(User user){

    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;

    try {
      auth.createUserWithEmailAndPassword(
          email: user.userEmail,
          password: user.userPassword
      ).then((firebaseUser){
        db.collection("users")
            .document(firebaseUser.user.uid)
            .setData(user.toMap());

        //Redireciona Usuario para o Painel conforme o tipo
        switch(user.userType){
          case "Driver" :
            Navigator.pushNamedAndRemoveUntil(
                context,
                "/panel-driver",
                    (_) => false
            );
            break;
        }

        switch(user.userType){
          case "Passenger" :
            Navigator.pushNamedAndRemoveUntil(
                context,
                "/panel-passenger",
                    (_) => false
            );
            break;
        }
      });

    } on PlatformException catch (error) {
      print("Error Code: " + error.code);
      switch(error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE" :
          setState(() {
            _errorMsg = "E-mail indisponivel !";
          });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.png"), fit: BoxFit.cover)),
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
                TextFormField(
                  controller: _controllerName,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.face,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                ),
                TextFormField(
                  controller: _controllerEmail,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                ),
                TextFormField(
                  controller: _controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                ),
                TextFormField(
                  controller: _controllerPasswordRepeat,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Repetir Senha",
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text("Passageiro"),
                      Switch(
                        value: _userType,
                        onChanged: (bool value) {
                          setState(() {
                            _userType = value;
                          });
                        },
                      ),
                      Text("Motorista"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Color(0xff1ebbd8),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    onPressed: () {
                      _formValidation();
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Já tem conta ? Entre aqui !",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMsg,
                      style: TextStyle(color: Colors.red, fontSize: 20),
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
