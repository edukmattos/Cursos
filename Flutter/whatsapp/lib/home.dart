import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'package:whatsapp/screens/tabConversations.dart';
import 'package:whatsapp/screens/tabContacts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<String> menuItems = ["Configurações", "Sair"];

  String _userEmail = "";

  Future _getUserLogged() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser userLogged = await auth.currentUser();

    setState(() {
      _userEmail = userLogged.email;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLogged();
    _tabController = TabController(length: 2, vsync: this);
  }

  _menuItemSelected(String itemSelected) {
    //print("Menu item: " + itemSelected);
    switch (itemSelected) {
      case "Configurações":
        Navigator.pushNamed(context, RouteGenerator.ROUTE_PROFILE);
        break;

      case "Sair":
        _logout();
        break;
    }
  }

  _logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_SIGNIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              text: "Conversas",
            ),
            Tab(
              text: "Contatos",
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _menuItemSelected,
            itemBuilder: (context) {
              return menuItems.map((String menuItem) {
                return PopupMenuItem<String>(
                  value: menuItem,
                  child: Text(menuItem),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[TabConversations(), TabContacts()],
      ),
    );
  }
}
