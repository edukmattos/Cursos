import 'package:flutter/material.dart';

import 'model/user.dart';

class Messages extends StatefulWidget {
  User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.contact.name)),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Text("listview"),
                  Text("Cx Mensages"),
                ],
              ),
            ),
          ),
        ));
  }
}
