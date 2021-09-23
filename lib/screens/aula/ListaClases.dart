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
  final controllerNom = new TextEditingController();


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
          'Aules',
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
                itemCount: _listaAulas.length,
                itemBuilder: (BuildContext context, index){
                  return InkWell(
                    onLongPress: (){
                      deleteClase(context, _listaAulas[index]);
                    },
                      onTap: (){
                        if(widget.user.userRole == "profesor"){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ListaAlumnos(widget.user, _listaAulas[index]))
                          );
                        }
                        else{
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ListaTests(widget.user, _listaAulas[index]))
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
          ),
          ElevatedButton(
            onPressed: () {
              addClase(context);
            },
            child: const Text('Afegir clase', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget padding(Widget widget){
    return Padding(padding: EdgeInsets.all(7.0), child: widget);
  }


  Future<void> deleteClase(context, Aula aula) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Eliminar alumne"),
          content: Text("Està segur que vol esborrar la classe " + aula.nombre + " de la llista?"),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancelar")),
            TextButton(
                onPressed: () async {
                  await http.delete(new Uri.http(apiURL, "/api/" + widget.user.email + "/clases/" + aula.id.toString()));
                  Navigator.pop(context);
                  setState(() {
                    getListaAulas();
                  });
                },
                child: Text("Esborrar", style: TextStyle(color: Colors.red),)),
          ],
        )
    );
  }


  Future<void> getListaAulas() async {

    http.Response response;
    if(widget.user.userRole == "profesor"){
      response = await http.get(new Uri.http(apiURL, "/api/usuarios/" + widget.user.email + "/aulas"));
    }
    else{
      response = await http.get(new Uri.http(apiURL, "/api/usuarios/" + widget.user.email + "/aulasPertany"));
    }

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaAulas = data.map((model) => Aula.fromJson(model)).toList();
    });
  }

  Future<void> addClase(context) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Afegir Clase"),
          content: TextFormField(
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'Nom de la Clase',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            controller: controllerNom,
            validator: (value) {
              if (value.isEmpty) {
                return 'No s\'ha escrit cap nom de la Clase.';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancelar")),
            TextButton(
                onPressed: () async {
                  await http.post(new Uri.http(apiURL, "/api/" + widget.user.email + "/clases" ),
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode(<String, dynamic>{
                        'nombre': controllerNom.text}));
                  Navigator.pop(context);
                  setState(() {
                    getListaAulas();
                  });
                },
                child: Text("Afegir", style: TextStyle(color: Colors.green),)),
          ],
        )
    );
  }
}
