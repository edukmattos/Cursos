import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //Controladores
  TextEditingController _controllerName = TextEditingController();
  File _imageUser;
  String _idUserLogged;
  bool _uploadingFile = false;
  String _urlUserImage;

  Future _getUserImage(String sourcUserImage) async {
    File selectedUserImage;

    switch (sourcUserImage) {
      case "camera":
        selectedUserImage =
            await ImagePicker.pickImage(source: ImageSource.camera);
        break;

      case "gallery":
        selectedUserImage =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imageUser = selectedUserImage;
      if (_imageUser != null) {
        _uploadingFile = true;
        _uploadUserImage();
      }
    });
  }

  Future _uploadUserImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference dirRoot = storage.ref();
    StorageReference file =
        dirRoot.child("profile").child(_idUserLogged + ".jpg");
    StorageUploadTask task = file.putFile(_imageUser);

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
      _getUrlUserImage(snapshot);
    });
  }

  Future _getUrlUserImage(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    _updateUrlUserImageFirestore(url);

    setState(() {
      _urlUserImage = url;
    });
  }

  _updateUserNameFirestore() {
    String name = _controllerName.text;

    Firestore db = Firestore.instance;

    Map<String, dynamic> dataToUpdate = {
      "name" : name
    };

    db.collection("users").document(_idUserLogged).updateData(dataToUpdate);
  }

  _updateUrlUserImageFirestore(String url) {
    Firestore db = Firestore.instance;

    Map<String, dynamic> dataToUpdate = {
      "urlImage" : url
    };

    db.collection("users").document(_idUserLogged).updateData(dataToUpdate);
  }

  _getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLogged = await auth.currentUser();
    _idUserLogged = userLogged.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("users")
    .document(_idUserLogged)
    .get();

    Map<String, dynamic> user = snapshot.data;
    _controllerName.text = user["name"];

    if(user["urlImage"] != null) {
      _urlUserImage = user["urlImage"];
      print("url: " + _urlUserImage);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: _uploadingFile ? CircularProgressIndicator() : Container(),
                ),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: _urlUserImage != null
                        ? NetworkImage(_urlUserImage)
                        : null),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Camera"),
                      onPressed: () {
                        _getUserImage("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: () {
                        _getUserImage("gallery");
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerName,
                    autofocus: false,
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
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Alterar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    onPressed: () {
                      _updateUserNameFirestore();
                    },
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
