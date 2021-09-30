import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Informe.dart';
import 'package:tfg/models/Test.dart';
import 'package:tfg/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/screens/menu/menu.dart';
import 'package:tfg/screens/test/Quiz.dart';

import '../home.dart';

class ListaInformes extends StatefulWidget{

  ListaInformes(this.user, this._listaInformes, this._listaProfes);
  User user;
  List<dynamic> _listaInformes;
  List<dynamic> _listaProfes;

  @override
  _ListaInformesState createState() => _ListaInformesState();
  
}

class _ListaInformesState extends State<ListaInformes>{




  Informe informe;


  @override
  List<dynamic> initState() {
    //getListaInformes();
    print("AQUI PONGO LA LISTA DE INFORMES: ");
    print(widget._listaInformes);

    print("AQUI PONGO LA LISTA DE PROFES: ");
    print(widget._listaProfes);
  }

  @override
  Widget build(BuildContext context) {

    print(widget._listaInformes);
    //getProfessores();

    return Scaffold(
      drawer: Menu(widget.user),
      appBar: AppBar(
        title: Text(
          'Tests',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget._listaInformes.length,
                itemBuilder: (BuildContext context, index){
                  return InkWell(
                      onTap: (){
                        if(widget.user.userRole == "professor"){
                          Navigator.pushReplacement(
                              context,
                        //MaterialPageRoute(builder: (context) => InformeVista(widget.user, _listaInformes[index]))
                            MaterialPageRoute(builder: (context) => Home(widget.user))
                          );
                        }
                        else{
                          Navigator.pushReplacement(
                              context,
                        //MaterialPageRoute(builder: (context) => InformeVista(widget.user, _listaInformes[index]))
                              MaterialPageRoute(builder: (context) => Home(widget.user))
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
                            Row(children: [
                              padding(Icon(Icons.school)),
                              padding(Text("Professor: " + widget._listaProfes[index].nombre, style: TextStyle(fontSize: 18.0))),
                            ],),
                            Row(children: <Widget>[
                              padding(Icon(Icons.timer)),
                              padding(Text("Data: " + widget._listaInformes[index].id.fecha.day.toString() + "/" + widget._listaInformes[index].id.fecha.month.toString() + "/" + widget._listaInformes[index].id.fecha.year.toString(), style: TextStyle(fontSize: 14.0)))
                            ],)
                          ],
                        ),
                      )
                  );
                }),
            ),
          ]
      )
    );
  }

  Widget padding(Widget widget){
    return Padding(padding: EdgeInsets.all(7.0), child: widget);
  }

}