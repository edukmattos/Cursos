import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String _idUserSender;
  String _idUserRecipient;
  String _fromUserName; //name
  String _message;
  String _pathUserImage;
  String _msgType;

  Conversation();

  save() async {
    /*
    + Conversas (collection)
      + Id Usuario remetente (document)
        + Última conversa (collection)
          + Id Usuário Destinatario (document)
            + Dados da conversa
    */
    Firestore db = Firestore.instance;
    await db
        .collection("conversations")
        .document(this.idUserSender)
        .collection("conversation_last")
        .document(this.idUserRecipient)
        .setData(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUserSender": this.idUserSender,
      "idUserRecipient": this.idUserRecipient,
      "nameUserRecipient": this.fromUserName,
      "message": this.message,
      "pathUserImage": this.pathUserImage,
      "msgType": this.msgType
    };

    return map;
  }

  String get idUserSender => _idUserSender;
  set idUserSender(String value) {
    _idUserSender = value;
  }

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

  String get idUserRecipient => _idUserRecipient;
  set idUserRecipient(String value) {
    _idUserRecipient = value;
  }

  String get msgType => _msgType;
  set msgType(String value) {
    _msgType = value;
  }
}
