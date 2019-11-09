class Destiny {

  String _street;
  String _building;
  String _city;
  String _state;
  String _neighborhood;
  String _zipCode;
  double _latitude;
  double _longitude;

  Destiny();

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  String get zipCode => _zipCode;

  set zipCode(String value) {
    _zipCode = value;
  }

  String get neighborhood => _neighborhood;

  set neighborhood(String value) {
    _neighborhood = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get building => _building;

  set building(String value) {
    _building = value;
  }

  String get street => _street;

  set street(String value) {
    _street = value;
  }


}