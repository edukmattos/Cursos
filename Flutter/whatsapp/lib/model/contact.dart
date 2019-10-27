class Contact {
  String _userName; //name
  String _pathUserImage;

  Contact(this._userName, this._pathUserImage);

  String get userName => _userName;
  set userName(String value) {
    _userName = value;
  }

  String get pathUserImage => _pathUserImage;
  set pathUserImage(String value) {
    _pathUserImage = value;
  }
}
