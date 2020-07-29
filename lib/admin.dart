import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  Map user;
  final VoidCallback signOut;
  Admin({this.user, this.signOut});
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administrateur"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power), onPressed: widget.signOut)
        ],
        centerTitle: true
      ),
      body: Center(child: Container(
        child: Column(
          children: <Widget>[
            Text("Nom: "+widget.user['nom'], style: TextStyle(fontSize: 25),),
            Text("Email: "+widget.user['email'], style: TextStyle(fontSize: 25),),
            Text("Age: "+widget.user['age'], style: TextStyle(fontSize: 25),),
          ],
        ),
      ),),
    );
  }
}