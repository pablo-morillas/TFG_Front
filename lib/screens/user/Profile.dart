import 'dart:convert';
import 'dart:io';

import 'package:tfg/global/global.dart';
import 'package:tfg/models/Aula.dart';
import 'package:tfg/models/Test.dart';
import 'package:tfg/models/TestResolt.dart';
import 'package:tfg/models/User.dart';
import 'package:tfg/screens/Informe/CreaInforme.dart';
import 'package:tfg/screens/aula/ListaAlumnos.dart';
import 'package:tfg/screens/menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget{
  Profile(this.user, this.aula, this.userVista);
  User user;
  User userVista;
  Aula aula;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{

  List<dynamic> _listaTests = [];

  @override
  List<dynamic> initState() {
    getListaTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ListaAlumnos(widget.user, widget.aula))
            );
          },
        ),
        title: Text(
          'Perfil d\'usuari',
          style: TextStyle(
            color: Colors.white,
          ),

        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context)=> CreaInforme(widget.user, widget.userVista))
                  );
                },
              icon: Icon(Icons.analytics_rounded)),
        ],
      ),
      body: Column(
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none ,
              alignment: Alignment.center,
              children: <Widget>[
                Image(
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                  image: NetworkImage('https://cdn.pixabay.com/photo/2014/02/01/17/28/apple-256263_960_720.jpg'),),
                Positioned(
                    bottom: -70,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),)
                ),
              ],
            ),
            SizedBox(height: 90.0,),
            ListTile(
              title: Center(child: Text(
                  widget.userVista.nombre,
                  style: TextStyle(
                    fontSize: 20,
                  )
              ),
              ),
            ),
            ListTile(
              title: Center(child: Text(
                  widget.userVista.email,
                  style: TextStyle(
                    fontSize: 16,
                  )
              ),
              ),
            ),
            SizedBox(height: 40,),
            Text("Notes tests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _listaTests.length,
                itemBuilder: (BuildContext context, index){
                  return ListTile(
                    title: Text(_listaTests[index].nomTest),
                    leading: Icon(Icons.library_books_rounded),

                    trailing: Text(_listaTests[index].nota.toString(), style: TextStyle(fontSize: 20),),
                  );
                }),
          ]
      ),
    );
  }

  Future<void> getListaTests() async {

    http.Response response = await http.get(new Uri.http(apiURL, "/api/usuarios/" + widget.userVista.email + "/examenresolts" ));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaTests = data.map((model) => TestResolt.fromJson(model)).toList();
    });

    print(_listaTests);
  }

}