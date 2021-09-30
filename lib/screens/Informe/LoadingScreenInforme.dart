import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Informe.dart';
import 'package:tfg/models/Test.dart';
import 'package:tfg/models/User.dart';
import 'package:tfg/screens/Informe/ListaInformes.dart';

class LoadingScreenInforme extends StatefulWidget {
  LoadingScreenInforme(this.user);
  User user;


  @override
  _LoadingInformeState createState() => _LoadingInformeState();
  }


class _LoadingInformeState extends State<LoadingScreenInforme> {

  List<dynamic> _listaInformes = [];
  List<dynamic> _listaProfes = [];

  var _responseCode;

  @override
  void initState() {
    getListaInformes();
  }

  void getListaInformes() async {


    http.Response response = await http.get(new Uri.http(apiURL, "/api/usuarios/" + widget.user.email + "/informes" ));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaInformes = data.map((model) => Informe.fromJson(model)).toList();
    });

    print(_listaInformes);

    if(_responseCode != 204){
      setState(() {
        getProfessores();
      });
    }

  }

  void getProfessores() async {
    for (Informe informe in _listaInformes){
      http.Response response = await http.get(new Uri.http(apiURL, "/api/usuarios/" + informe.id.professor));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      print("AQUI NO FALLA: ");

      setState((){
        _listaProfes.add(User.fromJson(jsonDecode(response.body)));
      });
    }
    print("PUES NO FALLA AQUI: ");

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>
            ListaInformes(widget.user, _listaInformes, _listaProfes))
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