import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp/model/message.dart';

import 'model/user.dart';

class Messages extends StatefulWidget {
  User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  String _idUserLogged;
  String _idUserRecipient;

  List<String> _msgList = [
    "Oi !",
    "Oi !",
    "Tudo bem ?",
    "Tudo. E ai'?",
    "Aqui ? Vamos indo.",
    "Vc viu as notícias da aprovação da Previdência ?",
    "Sim, ouvi. Não adianta nada argumentar, eles querem aprovar de qualquer para fazer com que o povo brasileiro sofra mais ainada !",
    "Pois é. De nada adianta se a roubalheira continuar !"
  ];

  TextEditingController _controllerMsgText = TextEditingController();

  _msgSend() {
    String _msgText = _controllerMsgText.text;
    if(_msgText.isNotEmpty){

      Message message = Message();

      message.idUser = _idUserLogged;
      message.msg = _msgText;
      message.urlFile = "";
      message.msgType = "text";

      _msgSave(_idUserLogged, _idUserRecipient, message);
    }
  }

  _msgSave(String idUserFrom, String idUserRecipient, Message msg) async {
    Firestore db = Firestore.instance;
    
    await db.collection("messages")
    .document(idUserFrom)
    .collection(idUserRecipient)
    .add(msg.toMap());

    _controllerMsgText.clear();
  }

  _fileSend() {}

  _getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLogged = await auth.currentUser();
    _idUserLogged = userLogged.uid;

    _idUserRecipient = widget.contact.idUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    var msgInputBox = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextFormField(
                controller: _controllerMsgText,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Informe uma mensagem",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        _fileSend();
                      },
                    )),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: () {
              _msgSend();
            },
          )
        ],
      ),
    );

    var listView = Expanded(
        child: ListView.builder(
      itemCount: _msgList.length,
      itemBuilder: (context, index) {

        double _widthContainer = MediaQuery.of(context).size.width * 0.8;

        Alignment _alignment = Alignment.centerRight;
        Color _color = Color(0xffd2ffa5);

        if(index % 2 == 0){
          _alignment = Alignment.centerLeft;
          _color = Colors.white;
        }

        return Align(
          alignment: _alignment,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Container(
              width: _widthContainer,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Text(
                _msgList[index],
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      },
    ));

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: widget.contact.urlImage != null
                      ? NetworkImage(widget.contact.urlImage)
                      : null),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Text(widget.contact.name)
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  listView,
                  msgInputBox,
                ],
              ),
            ),
          ),
        ));
  }
}
