class User {
  String _userId;
  String _userName;
  String _userEmail;
  String _userPassword;
  String _userType;

  double _userLatitude;
  double _userLongitude;

  User();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "name": this.userName,
      "email": this.userEmail,
      "type": this.userType,
      "latitude": this._userLatitude,
      "longitude": this._userLongitude,
    };

    return map;
  }

  String userTypeCheck(bool userType){
    return userType ? "Driver" : "Passenger";
  }

  String get userType => _userType;

  set userType(String value) {
    _userType = value;
  }

  String get userPassword => _userPassword;

  set userPassword(String value) {
    _userPassword = value;
  }

  String get userEmail => _userEmail;

  set userEmail(String value) {
    _userEmail = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  double get userLatitude => _userLatitude;

  set userLatitude(double value) {
    _userLatitude = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  double get userLongitude => _userLongitude;

  set userLongitude(double value) {
    _userLongitude = value;
  }
}