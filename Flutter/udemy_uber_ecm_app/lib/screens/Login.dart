import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:udemy_uber_app/model/User.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail =
      TextEditingController(text: "edukmattos@gmail.com");
  TextEditingController _controllerPassword =
      TextEditingController(text: "secret");

  String _errorMsg = "";
  bool _loading = false;

  _formValidation() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty) {
      if (email.contains("@")) {
        if (password.isNotEmpty) {
          if (password.length >= 6) {
            User user = User();

            user.userEmail = email;
            user.userPassword = password;

            _login(user);
          } else {
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
  }

  _login(User user) {

    setState(() {
      _loading = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
            email: user.userEmail, password: user.userPassword)
        .then((firebaseUser) {
      _userTypeRedirectToPanel(firebaseUser.user.uid);
    }).catchError((error) {
      _errorMsg = "Nao possivel autenticar";
    });
  }

  _userTypeRedirectToPanel(String userId) async {
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("users").document(userId).get();

    Map<String, dynamic> results = snapshot.data;
    String userType = results["type"];

    setState(() {
      _loading = false;
    });

    switch (userType) {
      case "Driver":
        Navigator.pushReplacementNamed(context, "/panel-driver");
        break;

      case "Passenger":
        Navigator.pushReplacementNamed(context, "/panel-passenger");
        break;
    }
  }

  _userLoggedCheck() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLogged = await auth.currentUser();
    if(userLogged != null) {
      String userId = userLogged.uid;
      _userTypeRedirectToPanel(userId);
    }
  }

  @override
  void initState() {
    super.initState();
    _userLoggedCheck();
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
                  controller: _controllerEmail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
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
                  keyboardType: TextInputType.emailAddress,
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
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Entrar",
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
                      "Não tem conta ? Cadastre-se !",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                  ),
                ),
                _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Container(),
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
