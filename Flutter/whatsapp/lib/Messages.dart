import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp/model/conversation.dart';
import 'package:whatsapp/model/message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'model/user.dart';

class Messages extends StatefulWidget {
  User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  File _msgFile;
  bool _uploadingFile = false;
  String _idUserLogged;
  String _idUserRecipient;
  Firestore db = Firestore.instance;
  TextEditingController _controllerMsgText = TextEditingController();

  _msgSend() {
    String _msgText = _controllerMsgText.text;
    if (_msgText.isNotEmpty) {
      Message message = Message();
      message.idUser = _idUserLogged;
      message.msg = _msgText;
      message.urlFile = "";
      message.msgType = "text";

      //Salvar mensagem texto
      //Remetente
      _msgSave(_idUserLogged, _idUserRecipient, message);
      //Destinatario
      _msgSave(_idUserRecipient, _idUserLogged, message);

      //Salvar última conversa
      _conversationSave(message);
    }
  }

  _conversationSave(Message message){
    //Remetente
    Conversation conversationSender = Conversation();
    conversationSender.idUserSender = _idUserLogged;
    conversationSender.idUserRecipient = _idUserRecipient;
    conversationSender.message = message.msg;
    conversationSender.fromUserName = widget.contact.name;
    conversationSender.pathUserImage = widget.contact.urlImage;
    conversationSender.msgType = message.msgType;
    conversationSender.save();

    //Destinatario
    Conversation conversationRecipient = Conversation();
    conversationRecipient.idUserSender = _idUserRecipient;
    conversationRecipient.idUserRecipient = _idUserLogged;
    conversationRecipient.message = message.msg;
    conversationRecipient.fromUserName = widget.contact.name;
    conversationRecipient.pathUserImage = widget.contact.urlImage;
    conversationRecipient.msgType = message.msgType;
    conversationRecipient.save();
  }

  _msgSave(String idUserFrom, String idUserRecipient, Message msg) async {
    await db
        .collection("messages")
        .document(idUserFrom)
        .collection(idUserRecipient)
        .add(msg.toMap());

    _controllerMsgText.clear();
  }

  _fileSend() async {
    File _msgFileSelected;
    _msgFileSelected = await ImagePicker.pickImage(source: ImageSource.gallery);

    _uploadingFile = true;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference dirRoot = storage.ref();
    StorageReference file =
        dirRoot.child("messages").child(_idUserLogged).child(fileName + ".jpg");
    StorageUploadTask task = file.putFile(_msgFileSelected);

    //Controlar o progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _uploadingFile = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _uploadingFile = false;
        });
      }
    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _getUrlFile(snapshot);
    });
  }

  Future _getUrlFile(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    Message message = Message();
    message.idUser = _idUserLogged;
    message.msg = "";
    message.urlFile = url;
    message.msgType = "image";

    _msgSave(_idUserLogged, _idUserRecipient, message);
    _msgSave(_idUserRecipient, _idUserLogged, message);

  }

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
              child: TextField(
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
                    prefixIcon:
                    _uploadingFile ? CircularProgressIndicator()
                        : IconButton(
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

    var stream = StreamBuilder(
      stream: db
          .collection("messages")
          .document(_idUserLogged)
          .collection(_idUserRecipient)
          .snapshots(),
      builder: (context, snapshot) {
        double _widthContainer = MediaQuery.of(context).size.width * 0.8;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:

            QuerySnapshot querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados!");
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, index) {
                      //recupera mensagem
                      List<DocumentSnapshot> messages =
                          querySnapshot.documents.toList();
                      DocumentSnapshot item = messages[index];

                      double _widthContainer =
                          MediaQuery.of(context).size.width * 0.8;

                      //Define cores e alinhamentos
                      Alignment alinhamento = Alignment.centerRight;
                      Color cor = Color(0xffd2ffa5);
                      if (_idUserLogged != item["idUser"]) {
                        alinhamento = Alignment.centerLeft;
                        cor = Colors.white;
                      }

                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            width: _widthContainer,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: cor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child:
                            item["msgType"] == "text"
                                ? Text(item["msg"],style: TextStyle(fontSize: 18),)
                              : Image.network(item["urlFile"]),
                          ),
                        ),
                      );
                    }),
              );
            }

            break;
        }
      },
    );

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
                  stream,
                  msgInputBox,
                ],
              ),
            ),
          ),
        ));
  }
}
