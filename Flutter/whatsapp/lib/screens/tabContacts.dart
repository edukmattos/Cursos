import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'package:whatsapp/model/contact.dart';
import 'package:whatsapp/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TabContacts extends StatefulWidget {
  @override
  _TabContactsState createState() => _TabContactsState();
}

class _TabContactsState extends State<TabContacts> {
  String _idUserLogged;
  String _emailUserLogged;

  Future<List<User>> _getContacts() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection("users").getDocuments();

    List<User> listUsers = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var getData = item.data;

      print(getData["email"]);

      if (getData["email"] == _emailUserLogged) continue;

      User user = User();
      user.idUser = item.documentID;
      user.name = getData["name"];
      user.email = getData["email"];
      user.urlImage = getData["urlImage"];

      listUsers.add(user);
    }
    return listUsers;
  }

  _getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLogged = await auth.currentUser();
    _idUserLogged = userLogged.uid;
    _emailUserLogged = userLogged.email;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _getContacts(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  List<User> listItems = snapshot.data;
                  User user = listItems[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteGenerator.ROUTE_MESSAGES,
                          arguments: user);
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: user.urlImage != null
                            ? NetworkImage(user.urlImage)
                            : null),
                    title: Text(
                      user.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                });
            break;
        }
      },
    );
  }
}
