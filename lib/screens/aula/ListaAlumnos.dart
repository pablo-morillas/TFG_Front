import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Aula.dart';
import 'package:tfg/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/screens/menu/menu.dart';

class ListaAlumnos extends StatefulWidget{

  ListaAlumnos(this.user, this.aula);
  User user;
  Aula aula;

  @override
  _ListaAlumnosState createState() => _ListaAlumnosState();
  
}

class _ListaAlumnosState extends State<ListaAlumnos>{

  List<dynamic> _listaAlumnos = [];

  User alumno;

  @override
  List<dynamic> initState() {
    getListaAlumnos();
  }

  @override
  Widget build(BuildContext context) {

    print(_listaAlumnos);

    return Column(
      children: [
        Scaffold(
          drawer: Menu(widget.user),
          appBar: AppBar(
            title: Text(
              'Alumnos',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: ListView.builder(
              shrinkWrap: true,
              itemCount: _listaAlumnos.length,
              itemBuilder: (BuildContext context, index){
                return ListTile(
                  title: Text(_listaAlumnos[index].nombre),
                    onLongPress: (){

                    },
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),)
                );
              }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Bottom Button!', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget padding(Widget widget){
    return Padding(padding: EdgeInsets.all(7.0), child: widget);
  }


  Future<void> getListaAlumnos() async {
    http.Response response = await http.get(new Uri.http(apiURL, "/api/" + widget.user.email + "/" + widget.aula.id.toString() + "/alumnos" ));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaAlumnos = data.map((model) => User.fromJson(model)).toList();
    });
  }
}