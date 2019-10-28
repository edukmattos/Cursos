class Message {
  String _idUser;
  String _msg;
  String _urlFile;
  String _msgType;

  Message();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": this.idUser,
      "msg": this.msg,
      "urlFile": this.urlFile,
      "msgType": this.msgType,
    };

    return map;
  }

  String get msgType => _msgType;
  set msgType(String value) {
    _msgType = value;
  }

  String get urlFile => _urlFile;
  set urlFile(String value) {
    _urlFile = value;
  }

  String get msg => _msg;
  set msg(String value) {
    _msg = value;
  }

  String get idUser => _idUser;
  set idUser(String value) {
    _idUser = value;
  }
}
