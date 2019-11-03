import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/model/conversation.dart';

class TabConversations extends StatefulWidget {
  @override
  _TabConversationsState createState() => _TabConversationsState();
}

class _TabConversationsState extends State<TabConversations> {
  List<Conversation> _listConversations = List();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  String _idUserLogged;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Stream<QuerySnapshot> _addListenerConversations() {
    final stream = db
        .collection("conversations")
        .document(_idUserLogged)
        .collection("conversation_last")
        .snapshots();

    stream.listen((getData) {
      _controller.add(getData);
    });
  }

  _getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLogged = await auth.currentUser();
    _idUserLogged = userLogged.uid;

    _addListenerConversations();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando conversas"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados!");
            } else {
              QuerySnapshot querySnapshot = snapshot.data;

              if (querySnapshot.documents.length == 0) {
                return Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda :( ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: _listConversations.length,
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> conversations =
                        querySnapshot.documents.toList();
                    DocumentSnapshot item = conversations[index];

                    String nameUserRecipient = item["nameUserRecipient"];
                    String message = item["msg"];
                    String urlFile = item["urlFile"];
                    String msgType = item["msgType"];

                    return ListTile(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            urlFile != null ? NetworkImage(urlFile) : null,
                      ),
                      title: Text(
                        nameUserRecipient,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(msgType == "text" ? message : "Imagem...",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    );
                  });
            }
            break;
        }
      },
    );
  }
}
