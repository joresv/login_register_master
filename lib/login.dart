import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginRegister/admin.dart';
import 'package:loginRegister/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final _key = GlobalKey<FormState>();
  void saveSession(Map user, int s) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("user", json.encode(user));
    p.setInt("statut", s);
    p.commit();
  }

  int statut = 0;
  Map user;
  void getSession() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    if (p.getInt("statut") == 1) {
      setState(() {
        statut = 1;
        user = json.decode(p.getString("user"));
      });
    } else {
      setState(() {
        statut = 0;
      });
    }
  }

  void login() async {
    if (_key.currentState.validate()) {
      if (_key.currentState.validate()) {
        final response = await http.post(
            "https://mesprojetsapp.000webhostapp.com/tutoyoutube/file.php",
            body: {"user": username.text, "type": '2', "pass": password.text});

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['val'] == 1) {
            message(data['statut']);
            print(data['info']);
            saveSession(data['info'], 1);
            getSession();
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin(user: data['info'],) ) );
          } else {
            message(data['statut']);
            print(data['user']);
          }
        }
      }
    }
  }

  logOut() async{
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      p.setString("user", null);
      p.setInt("statut", null);
      statut = 0;
      p.commit();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    switch (statut) {
      case 1:
      return Admin(user: user, signOut: logOut);
        break;
      case 0:
        return Scaffold(
          backgroundColor: Color.fromRGBO(44, 44, 44, 0.6),
          body: Center(
              child: SingleChildScrollView(
                  child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    Image(image: AssetImage("images/login.PNG")),
                    Card(
                      child: TextFormField(
                        controller: username,
                        validator: (e) =>
                            e.isEmpty ? "Veillez spécifier ce champ" : null,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(
                                Icons.person,
                                size: 30,
                              ),
                            ),
                            labelText: "Login",
                            hintText: "nom d'utilisateur"),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Card(
                      child: TextFormField(
                        controller: password,
                        validator: (e) =>
                            e.isEmpty ? "Veillez spécifier ce champ" : null,
                        style: TextStyle(fontSize: 20),
                        obscureText: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(
                                Icons.phonelink_lock,
                                size: 30,
                              ),
                            ),
                            labelText: "Password",
                            hintText: "votre mot de passe"),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    FlatButton(
                        onPressed: getSession,
                        child: Text(
                          "Forgot password",
                          style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        onPressed: login,
                        color: Colors.lightBlueAccent,
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 19, color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Avez-vous un compte? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    )
                  ],
                )),
          ))),
        );
      default:
    }
  }
}
