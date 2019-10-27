import 'package:flutter/material.dart';
import 'package:whatsapp/model/conversation.dart';

class TabConversations extends StatefulWidget {
  @override
  _TabConversationsState createState() => _TabConversationsState();
}

class _TabConversationsState extends State<TabConversations> {
  List<Conversation> listConversations = [
    Conversation("Ana Clara", "Olá ! Tudo bem ?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=f7e35d81-0236-4e72-8cb9-27ab3c8cc128"),
    Conversation("João Carlos", "Estou quase chegando.",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil2.jpg?alt=media&token=7d0e8543-68c3-41d4-91d1-80d363988f8e"),
    Conversation("Ana Luisa", "Desculpe ! Estou doente.",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil3.jpg?alt=media&token=367d8519-7713-48c0-8205-9b13c47addc2"),
    Conversation("Roberto Carlos", "Tudo bem. Marcado.",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil4.jpg?alt=media&token=76b83cad-4100-4969-972d-add05b31a340"),
    Conversation("Rodolfo Santos", "Tem prova hoje ?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil5.jpg?alt=media&token=37617313-9196-4d53-a3f6-d8218d05abee"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listConversations.length,
        itemBuilder: (context, index) {
          Conversation conversation = listConversations[index];

          return ListTile(
              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(conversation.pathUserImage),
              ),
              title: Text(
                conversation.fromUserName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                conversation.message,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ));
        });
  }
}
