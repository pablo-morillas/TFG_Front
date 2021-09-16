import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Aula.dart';
import 'package:http/http.dart' as http;

class CardAula extends StatelessWidget{
  Aula aula;
  CardAula(this.aula);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Nombre "+ aula.nombre)));
      },
        child: Card(
           child: Column(
          children: <Widget>[
            Container(
              height: 144.0,
              width: 500,
              //child: Image,
            ),
            padding(Text(aula.nombre, style: TextStyle(fontSize: 18.0))),
            Row(children: <Widget>[
              padding(Icon(Icons.person)),
              padding(Text(aula.profesor.nombre, style: TextStyle(fontSize: 18.0)))
            ],)
          ],
        ),
      )
    );
  }

  Widget padding(Widget widget){
    return Padding(padding: EdgeInsets.all(7.0), child: widget);
  }
}

