import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Test.dart';
import 'package:tfg/models/User.dart';

import 'home.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen(this.user, this.test, this._puntuacion);
  User user;
  Test test;
  int _puntuacion;


  @override
  _LoadingState createState() => _LoadingState();
  }


class _LoadingState extends State<LoadingScreen> {

  var _responseCode;

  @override
  void initState() {
    testRealizado();
  }

  void testRealizado() async {

    int nota = (widget._puntuacion / 10).round();

    http.Response response = await http.post(new Uri.http(apiURL, "/api/testRespondido"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': widget.user.token,
        },
        body: jsonEncode({
          'id': {
            'alumnoId': widget.user.email,
            'testId': widget.test.id.toString(),
          },
          'nota': nota.toString(),
        }));
    _responseCode = response.statusCode;

    print(_responseCode);

    if(_responseCode != 400){
      addPuntuacio();
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(widget.user))
    );
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