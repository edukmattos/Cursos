class Conversation {
  String _fromUserName; //name
  String _message;
  String _pathUserImage;

  Conversation(this._fromUserName, this._message, this._pathUserImage);

  String get fromUserName => _fromUserName;
  set fromUserName(String value) {
    _fromUserName = value;
  }

  String get message => _message;
  set message(String value) {
    _message = value;
  }

  String get pathUserImage => _pathUserImage;
  set pathUserImage(String value) {
    _pathUserImage = value;
  }
}
