import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/global/global.dart';
import 'package:tfg/models/User.dart';

import 'home.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen(this.user, this._puntuacion);
  User user;
  int _puntuacion;


  @override
  _LoadingState createState() => _LoadingState();
  }


class _LoadingState extends State<LoadingScreen> {

  @override
  void initState() {
    addPuntuacio();
  }

  void addPuntuacio() async {
    await http.put(new Uri.http(apiURL, "/api/usuarios/" + widget.user.email + "/puntos"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': widget.user.token,
        },
        body: jsonEncode(<String, String>{
          'email': widget.user.email,
          'puntos': widget._puntuacion.toString(),
        }));


    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(widget.user))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}