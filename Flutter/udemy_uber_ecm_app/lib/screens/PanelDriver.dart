import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udemy_uber_app/util/TravelStatus.dart';
import 'package:udemy_uber_app/util/UtilFirebaseUser.dart';

class PanelDriver extends StatefulWidget {
  @override
  _PanelDriverState createState() => _PanelDriverState();
}

class _PanelDriverState extends State<PanelDriver> {

  List<String> menuItensOptions = [
    "Configuracoes",
    "Sair"
  ];

  final _controller = StreamController<QuerySnapshot>.broadcast();

  Firestore db = Firestore.instance;

  _logoff() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, "/");
  }

  _menuItemSelected(String option){
    switch(option){
      case "Sair" :
        _logoff();
        break;
    }
  }

  Stream<QuerySnapshot> _travelsWaitingListener() {
    final stream = db.collection("travels")
        .where("status", isEqualTo: TravelStatus.WAITING)
        .snapshots();

    stream.listen((data){
      _controller.add(data);
    });
  }

  _travelOpened() async {
    //Recupera dados do Usuario logado
    FirebaseUser utilFirebaseUser = await UtilFirebaseUser.getUserLogged();

    //Recupera Travel Ativa
    DocumentSnapshot documentSnapshot = await db
        .collection("tmp_travels_opened_by_drivers")
        .document(utilFirebaseUser.uid)
        .get();

    var travel = documentSnapshot.data;

    if(travel == null){
      _travelsWaitingListener();
    }else{
      String travelId = travel["id"];
      Navigator.pushReplacementNamed(
          context,
          "/travel",
          arguments: travelId
      );
    }


  }

  @override
  void initState() {
    super.initState();
    /*
    Recupera a Travel Opened para verificar se o Motorista está
    atendendo alguma Travel e envia pata a tela Travel
    */
    _travelOpened();
  }
  @override

  var _loadingMsg = Center(
    child: Column(
      children: <Widget>[
        Text("Carregando"),
        CircularProgressIndicator()
      ],
    ),
  );

  var _travelsEmpty = Center(
    child: Text("Sem viagens aguardando !",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
    ),
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel Motorista"),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: _menuItemSelected,
          itemBuilder: (context){
            return menuItensOptions.map((String item){
              return PopupMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList();
          },
        )
      ],
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _loadingMsg;
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasError){
              return Text("Erro ao carregar");
            }else{
              QuerySnapshot querySnapshot = snapshot.data;
              if(querySnapshot.documents.length == 0){
                return _travelsEmpty;
              }else{
                return ListView.separated(
                  itemCount: querySnapshot.documents.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  itemBuilder: (context, index) {

                    List<DocumentSnapshot> travels = querySnapshot.documents.toList();
                    DocumentSnapshot item = travels[index];

                    String travelId = item["id"];
                    String passengerName = item["passenger"]["name"];
                    String destinyStreet = item["destiny"]["street"];
                    String destinyBuilding = item["destiny"]["building"];

                    return ListTile(
                      title: Text(passengerName),
                      subtitle: Text("Destino: $destinyStreet, $destinyBuilding"),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            "/travel",
                          arguments: travelId
                        );
                      },
                    );

                  },
                );
              }
            }
            break;
        }
      },
    ),
    );
  }
}
