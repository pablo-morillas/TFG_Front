import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Aula.dart';
import 'package:tfg/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/screens/menu/menu.dart';
import 'package:tfg/screens/test/ListaTests.dart';

import 'ListaAlumnos.dart';

class ListaClases extends StatefulWidget{

  ListaClases(this.user);
  User user;

  @override
  _ListaClasesState createState() => _ListaClasesState();
  
}

class _ListaClasesState extends State<ListaClases>{

  List<dynamic> _listaAulas = [];
  Aula aula;

  @override
  List<dynamic> initState() {
    getListaAulas();
  }

  @override
  Widget build(BuildContext context) {

    print(_listaAulas);

    return Scaffold(
      drawer: Menu(widget.user),
      appBar: AppBar(
        title: Text(
          'Aulas',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: _listaAulas.length,
          itemBuilder: (BuildContext context, index){
            return InkWell(
                onTap: (){
                  aula = _listaAulas[index];
                  if(widget.user.userRole == "profesor"){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ListaAlumnos(widget.user, aula))
                    );
                  }
                  else{
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ListaTests(widget.user, aula))
                    );
                  }

                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 144.0,
                        width: 500,
                        child: Image.network('https://cdn.pixabay.com/photo/2019/03/30/20/51/test-4092022_960_720.jpg', fit: BoxFit.fill)
                      ),
                      padding(Text(_listaAulas[index].nombre, style: TextStyle(fontSize: 18.0))),
                      Row(children: <Widget>[
                        padding(Icon(Icons.school)),
                        padding(Text(_listaAulas[index].profesor.nombre, style: TextStyle(fontSize: 18.0)))
                      ],)
                    ],
                  ),
                )
            );
          }),
    );
  }

  Widget padding(Widget widget){
    return Padding(padding: EdgeInsets.all(7.0), child: widget);
  }


  Future<void> getListaAulas() async {

    http.Response response;
    if(widget.user.userRole == "profesor"){
      response = await http.get(new Uri.http(apiURL, "/api/usuarios/" + widget.user.email + "/aulas"));
    }
    else{
      response = await http.get(new Uri.http(apiURL, "/api/usuarios/" + widget.user.email + "/clasesPertany"));
    }

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaAulas = data.map((model) => Aula.fromJson(model)).toList();
    });
  }
}