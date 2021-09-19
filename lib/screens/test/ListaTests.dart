import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Aula.dart';
import 'package:tfg/models/Test.dart';
import 'package:tfg/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/screens/menu/menu.dart';
import 'package:tfg/screens/test/Quiz.dart';

class ListaTests extends StatefulWidget{

  ListaTests(this.user, this.aula);
  User user;
  Aula aula;

  @override
  _ListaTestsState createState() => _ListaTestsState();
  
}

class _ListaTestsState extends State<ListaTests>{

  List<dynamic> _listaTests = [];

  Test test;

  @override
  List<dynamic> initState() {
    getListaTests();
  }

  @override
  Widget build(BuildContext context) {

    print(_listaTests);

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
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: _listaTests.length,
          itemBuilder: (BuildContext context, index){
            return ListTile(
              title: Text(_listaTests[index].nombre),
                onTap: (){
                  test = _listaTests[index];

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Quiz(widget.user, widget.aula, test))
                  );

                },
              trailing: Icon(Icons.arrow_forward_ios),
            );
          }),
    );
  }

  Widget padding(Widget widget){
    return Padding(padding: EdgeInsets.all(7.0), child: widget);
  }


  Future<void> getListaTests() async {
    int aulaId = widget.aula.id;
    http.Response response = await http.get(new Uri.http(apiURL, "/api/" + widget.user.email + "/" + widget.aula.id.toString() + "/tests" ));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaTests = data.map((model) => Test.fromJson(model)).toList();
    });
  }
}