import 'package:flutter/material.dart';
import 'package:whatsapp/model/contact.dart';

class TabContacts extends StatefulWidget {
  @override
  _TabContactsState createState() => _TabContactsState();
}

class _TabContactsState extends State<TabContacts> {
  List<Contact> listContacts = [
    Contact("Ana Clara",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=f7e35d81-0236-4e72-8cb9-27ab3c8cc128"),
    Contact("João Carlos",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil2.jpg?alt=media&token=7d0e8543-68c3-41d4-91d1-80d363988f8e"),
    Contact("Ana Luisa",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil3.jpg?alt=media&token=367d8519-7713-48c0-8205-9b13c47addc2"),
    Contact("Roberto Carlos",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil4.jpg?alt=media&token=76b83cad-4100-4969-972d-add05b31a340"),
    Contact("Rodolfo Santos",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c7511.appspot.com/o/profile%2Fperfil5.jpg?alt=media&token=37617313-9196-4d53-a3f6-d8218d05abee"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listContacts.length,
        itemBuilder: (context, index) {
          Contact contact = listContacts[index];

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(contact.pathUserImage),
            ),
            title: Text(
              contact.userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );
        });
  }
}
