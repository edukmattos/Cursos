import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_uber_app/model/Destiny.dart';
import 'package:udemy_uber_app/model/User.dart';

class Travel {
  String _id;
  String _status;
  User _passenger;
  User _driver;
  Destiny _destiny;

  Travel() {
    Firestore db = Firestore.instance;

    DocumentReference ref = db.collection("travels").document();
    this.id = ref.documentID;
  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> passengerData = {
      "name": this.passenger.userName,
      "email": this.passenger.userEmail,
      "type": this.passenger.userType,
      "userId": this.passenger.userId,
      "latitude": this.passenger.userLatitude,
      "longitude": this.passenger.userLongitude,
    };

    Map<String, dynamic> destinyData = {
      "street": this.destiny.street,
      "building": this.destiny.building,
      "neighborhood": this.destiny.neighborhood,
      "zipCode": this.destiny.zipCode,
      "latitude": this.destiny.latitude,
      "longitude": this.destiny.longitude,
    };

    Map<String, dynamic> travelData = {
      "id": this.id,
      "status": this.status,
      "passenger": passengerData,
      "driver": null,
      "destiny": destinyData,
    };

    return travelData;
  }

  Destiny get destiny => _destiny;

  set destiny(Destiny value) {
    _destiny = value;
  }

  User get driver => _driver;

  set driver(User value) {
    _driver = value;
  }

  User get passenger => _passenger;

  set passenger(User value) {
    _passenger = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}