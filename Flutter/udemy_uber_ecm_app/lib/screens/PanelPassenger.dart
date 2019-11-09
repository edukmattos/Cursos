import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import 'package:udemy_uber_app/model/Destiny.dart';
import 'package:udemy_uber_app/model/Travel.dart';
import 'package:udemy_uber_app/model/User.dart';
import 'package:udemy_uber_app/util/TravelStatus.dart';
import 'package:udemy_uber_app/util/UtilFirebaseUser.dart';

class PanelPassenger extends StatefulWidget {
  @override
  _PanelPassengerState createState() => _PanelPassengerState();
}

class _PanelPassengerState extends State<PanelPassenger> {
  TextEditingController _controllerDestiny =
      TextEditingController(text: "R Dr Gastao Rhodes, 118");

  List<String> menuItensOptions = ["Configuracoes", "Sair"];

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-30.069358, -51.208762));

  Position _userTypePassengerPosition;

  Set<Marker> _markers = {};

  String _travelId;

  //Controles para exibicao na tela
  bool _inputAddressFromAndTo = true;
  String _buttonText = "Chamar Uber";
  Color _buttonColor = Color(0xff1ebbd8);
  Function _buttomFunction;

  _logoff() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, "/");
  }

  _menuItemSelected(String option) {
    switch (option) {
      case "Sair":
        _logoff();
        break;
    }
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _userPositionListener() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _userTypePassengerMarkerShow(position);

      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );
      _cameraMove(_cameraPosition);

      setState(() {
        _userTypePassengerPosition = position;
      });
    });
  }

  _userPositionLast() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if (position != null) {
        _userTypePassengerMarkerShow(position);

        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        );
        _cameraMove(_cameraPosition);

        _userTypePassengerPosition = position;
      }
    });
  }

  _cameraMove(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _userTypePassengerMarkerShow(Position local) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "images/passenger.png")
        .then((BitmapDescriptor icone) {
      Marker userTypePassengerMarker = Marker(
          markerId: MarkerId("marker-passenger"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: "Meu local"),
          icon: icone);

      setState(() {
        _markers.add(userTypePassengerMarker);
      });
    });
  }

  _saveTravel(Destiny destiny) async {
    User passenger = await UtilFirebaseUser.getUserLoggedData();
    passenger.userLatitude = _userTypePassengerPosition.latitude;
    passenger.userLongitude = _userTypePassengerPosition.longitude;

    Travel travel = Travel();
    travel.destiny = destiny;
    travel.passenger = passenger;
    travel.status = TravelStatus.WAITING;

    Firestore db = Firestore.instance;

    //Salvar Travel - Inicio
    db.collection("travels").document(travel.id).setData(travel.toMap());
    //Salvar Travel - Inicio

    //Salvar Travel Open (Viagens Ativas) - Inicio
    //tmp_travels_opened_by_passengers
    // !-> userId
    //     |-> Travel Waiting
    Map<String, dynamic> travelOpen = {};
    travelOpen["id"] = travel.id;
    travelOpen["userId"] = passenger.userId;
    travelOpen["status"] = TravelStatus.WAITING;

    db
        .collection("tmp_travels_opened_by_passengers")
        .document(passenger.userId)
        .setData(travelOpen);
    //_travelStatusWaiting();
    //Salvar Travel Open (Viagens em Aberto) - Fim
  }

  _buttonChange(String text, Color color, Function function) {
    setState(() {
      _buttonText = text;
      _buttonColor = color;
      _buttomFunction = function;
    });
  }

  _travelOpening() {
    _inputAddressFromAndTo = true;
    _buttonChange("Chamar Uber", Color(0xff1ebbd8), () {
      print("QQQQQ");
      _travelConfirm();
    });
  }

  _travelStatusWaiting() {
    _inputAddressFromAndTo = false;
    //print("CANCELAR");
    _buttonChange("Cancelar Uber", Colors.red, () {
      //print("CANCELADA");
      _travelCancel();
    });
  }

  _travelStatusOnWay() {
    _inputAddressFromAndTo = false;
    _buttonChange("Motorista a caminho", Colors.grey, null);
  }


  _travelConfirm() async {
    print("Travel_confirm");
    String addressDestiny = _controllerDestiny.text;

    if (addressDestiny.isNotEmpty) {
      List<Placemark> addresses =
      await Geolocator().placemarkFromAddress(addressDestiny);

      if (addresses != null && addresses.length > 0) {
        Placemark address = addresses[0];

        Destiny destiny = Destiny();

        destiny.city = address.subAdministrativeArea;
        destiny.state = address.administrativeArea;
        destiny.zipCode = address.postalCode;
        destiny.neighborhood = address.subLocality;
        destiny.street = address.thoroughfare;
        destiny.building = address.subThoroughfare;

        destiny.latitude = address.position.latitude;
        destiny.longitude = address.position.longitude;

        String addressConfirmation;
        addressConfirmation = "\n" + destiny.street + ", " + destiny.building;
        addressConfirmation += "\n" + destiny.neighborhood;
        addressConfirmation += "\n" + destiny.city + "/" + destiny.state;
        addressConfirmation += "\n" + destiny.zipCode;

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Confirmar Destino ?"),
                content: Text(addressConfirmation),
                contentPadding: EdgeInsets.all(16),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Não",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Sim",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      print("Travel Confirm");
                      Navigator.pop(context);
                      _saveTravel(destiny);
                    },
                  )
                ],
              );
            });
      }
    }
  }

  _travelCancel() async {
    print("CANCELAR");
    FirebaseUser utilFirebaseUser = await UtilFirebaseUser.getUserLogged();

    Firestore db = Firestore.instance;
    await db
        .collection("travels")
        .document(_travelId)
        .updateData({"status": TravelStatus.CANCELED}).then((_) {
      db.collection("tmp_travels_opened_by_passengers").document(utilFirebaseUser.uid).delete();
    });
    print("CANCELADA");
  }

  _travelOpenedListener() async {
    //Recupera dados do Usuario logado
    FirebaseUser utilFirebaseUser = await UtilFirebaseUser.getUserLogged();

    //Recupera Travel Ativa
    Firestore db = Firestore.instance;

    await db
        .collection("tmp_travels_opened_by_passengers")
        .document(utilFirebaseUser.uid)
        .snapshots()
        .listen((snapshot) {
      print("Travels Open atualizada: " + snapshot.data.toString());

      //Caso exista uma Travel Open
      // |-> Altera a interface de acordo com o status
      //
      //Caso não tenha
      // |-> Exibe interface padrao para chamar Uber
      if (snapshot.data != null) {
        Map<String, dynamic> travelOpen = snapshot.data;

        String status = travelOpen["status"];

        _travelId = travelOpen["id"];

        switch (status) {
          case TravelStatus.WAITING:
            _travelStatusWaiting();
            break;
          case TravelStatus.ON_WAY:
            _travelStatusOnWay();
            break;
          case TravelStatus.TRAVELING:
            break;
          case TravelStatus.FINISHED:
            break;
        }
      } else {
        print("OPENING");
        _travelOpening();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _userPositionLast();
    _userPositionListener();
    //_travelStatusOpen();

    // Adicionar Listener TravelOpen
    _travelOpenedListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel Passageiro"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _menuItemSelected,
            itemBuilder: (context) {
              return menuItensOptions.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition,
              onMapCreated: _onMapCreated,
              //myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
            ),
            Visibility(
              visible: _inputAddressFromAndTo,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white),
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              icon: Container(
                                margin: EdgeInsets.only(left: 20),
                                width: 10,
                                height: 10,
                                child: Icon(Icons.location_on,
                                    color: Colors.green),
                              ),
                              hintText: "Meu local",
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, top: 16)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white),
                        child: TextField(
                          controller: _controllerDestiny,
                          readOnly: false,
                          decoration: InputDecoration(
                              icon: Container(
                                margin: EdgeInsets.only(left: 20),
                                width: 10,
                                height: 10,
                                child:
                                    Icon(Icons.local_taxi, color: Colors.black),
                              ),
                              hintText: "Destino",
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, top: 16)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: Platform.isIOS
                    ? EdgeInsets.fromLTRB(20, 10, 20, 25)
                    : EdgeInsets.all(10),
                child: RaisedButton(
                  child: Text(
                    _buttonText,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: _buttonColor,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  onPressed: () {
                    _buttomFunction();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
