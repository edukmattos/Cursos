import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:udemy_uber_app/model/User.dart';
import 'package:udemy_uber_app/util/TravelStatus.dart';
import 'package:udemy_uber_app/util/UtilFirebaseUser.dart';

class Travel extends StatefulWidget {
  String travelId;
  Travel(this.travelId);

  @override
  _TravelState createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-30.069358, -51.208762));

  Set<Marker> _markers = {};
  Map<String, dynamic> _travel;
  Position _userTypeDriverPosition;

  //Controles para exibicao na tela
  String _buttonText = "Aceitar Viagem";
  Color _buttonColor = Color(0xff1ebbd8);
  Function _buttomFunction;
  String _travelStatusMsg;

  _buttonChange(String text, Color color, Function function) {
    setState(() {
      _buttonText = text;
      _buttonColor = color;
      _buttomFunction = function;
    });
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

      _userTypePassengerMarkerShow(position);
      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );
      //_cameraMove(_cameraPosition);

      setState(() {
        _userTypeDriverPosition = position;
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
        //_cameraMove(_cameraPosition);
        _userTypeDriverPosition = position;
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
            "images/driver.png")
        .then((BitmapDescriptor icone) {
      Marker userTypePassengerMarker = Marker(
          markerId: MarkerId("marker-driver"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: "Meu local"),
          icon: icone);

      setState(() {
        _markers.add(userTypePassengerMarker);
      });
    });
  }

  _travelData() async {
    String travelId = widget.travelId;

    Firestore db = Firestore.instance;
    DocumentSnapshot documentSnapshot =
        await db.collection("travels").document(travelId).get();

    //_travel = documentSnapshot.data;

    //_travelListener();
  }

  _travelListener() async {
    Firestore db = Firestore.instance;

    String travelId = _travel["id"];

    await db.collection("travels")
    .document(travelId).snapshots().listen((snapshot){
      if(snapshot.data != null){
        _travel = snapshot.data;
        Map<String, dynamic> data = snapshot.data;

        String status = data["status"];
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
      }
    });
  }

  _travelStatusWaiting() {
    _travelStatusMsg = "";
    _buttonChange("Aceitar Viagem", Color(0xff1ebbd8), () {
      _travelAccept();
    });
  }

  _travelStatusOnWay() {
    _travelStatusMsg = "A caminho do passageiro";
    _buttonChange("Iniciar viagem", Color(0xff1ebbd8), null);

    double userTypePassengerLatitude = _travel["passenger"]["latitude"];
    double userTypePassengerLongitude = _travel["passenger"]["longitude"];

    double userTypeDriverLatitude = _travel["driver"]["latitude"];
    double userTypeDriverLongitude = _travel["driver"]["longitude"];

    _markersDriverPassengerShow(
      LatLng(userTypeDriverLatitude, userTypeDriverLongitude),
      LatLng(userTypePassengerLatitude, userTypePassengerLongitude),
    );

    // southwest.latitude <= northeast.latitude
    var nLat, nLon, sLat, sLon;

    if(userTypeDriverLatitude <= userTypePassengerLatitude) {
      sLat = userTypeDriverLatitude;
      nLat = userTypePassengerLatitude;
    }else{
      sLat = userTypePassengerLatitude;
      nLat = userTypeDriverLatitude;
    }

    if(userTypeDriverLongitude <= userTypePassengerLongitude) {
      sLon = userTypeDriverLongitude;
      nLon = userTypePassengerLongitude;
    }else{
      sLon = userTypePassengerLongitude;
      nLon = userTypeDriverLongitude;
    }

    _cameraBoundsMove(
      LatLngBounds(
        northeast: LatLng(nLat, nLon),
        southwest: LatLng(sLat, sLon)
      )
    );
  }

  _travelStart(){

  }

  _cameraBoundsMove(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(
      CameraUpdate.newLatLngBounds(
          latLngBounds,
          100
      )
    );
  }

  _markersDriverPassengerShow(LatLng latLngDriver, LatLng latLngPassenger){
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    Set<Marker> _markersAll  = {};

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: pixelRatio),
        "images/driver.png")
        .then((BitmapDescriptor icone) {
      Marker userTypeDriverMarker = Marker(
          markerId: MarkerId("marker-driver"),
          position: LatLng(latLngDriver.latitude, latLngDriver.longitude),
          infoWindow: InfoWindow(title: "Motorista"),
          icon: icone);

      _markersAll.add(userTypeDriverMarker);
    });

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: pixelRatio),
        "images/passenger.png")
        .then((BitmapDescriptor icone) {
      Marker userTypePassengerMarker = Marker(
          markerId: MarkerId("marker-passenger"),
          position: LatLng(latLngPassenger.latitude, latLngPassenger.longitude),
          infoWindow: InfoWindow(title: "Eu"),
          icon: icone);

      _markersAll.add(userTypePassengerMarker);
    });

    setState(() {
      _markers = _markersAll;
      /*_cameraMove(
          CameraPosition(
            target: LatLng(latLngDriver.latitude, latLngPassenger.longitude),
            zoom: 18
          ));
       */
    });
  }


  _travelAccept() async {
    //Recupera dados do motrista
    User driver = await UtilFirebaseUser.getUserLoggedData();
    driver.userLatitude = _userTypeDriverPosition.latitude;
    driver.userLongitude = _userTypeDriverPosition.longitude;

    Firestore db = Firestore.instance;

    String travelId = _travel["id"];

    db.collection("travels")
    .document(travelId)
    .updateData({
      "driver": driver.toMap(),
      "status": TravelStatus.ON_WAY
    }).then((_){

      //Atualiza Travel Open
      String userTypePassengerId = _travel["passenger"]["userId"];
      db.collection("tmp_travels_opened_by_passengers")
      .document(userTypePassengerId)
      .updateData({
        "status": TravelStatus.ON_WAY
      });

      //Salva Travel Open para o motorista
      String userTypeDriverId = driver.userId;
      db.collection("tmp_travels_opened_by_drivers")
          .document(userTypeDriverId)
          .setData({
            "id": travelId,
            "userId": userTypeDriverId,
            "status": TravelStatus.ON_WAY
          });
    });
  }


  @override
  void initState() {
    super.initState();
    _userPositionLast();
    _userPositionListener();

    //Adicionar Listener para mudanca da Travel
    _travelListener();
    //_travelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel Viagem "),
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
