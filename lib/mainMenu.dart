import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MainMenu extends StatefulWidget {

  final VoidCallback signOut;

  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut(){
    Toast.show("Anda Telah Logout", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    setState(() {
      widget.signOut();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : new Text("Darul Abidin"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.lock_open),
              onPressed: () {signOut();},
          )
        ],
      ),
      body: Center(
        child: Text("Main Menu"),
      ),
    );
  }
}
