import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Aula.dart';
import 'package:tfg/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/screens/menu/menu.dart';
import 'package:tfg/screens/test/CreaTest.dart';
import 'package:tfg/screens/user/Profile.dart';

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

  final controllerEmail = new TextEditingController();


  @override
  List<dynamic> initState() {
    getListaAlumnos();
  }

  @override
  Widget build(BuildContext context) {

    print(_listaAlumnos);

    return Scaffold(
      drawer: Menu(widget.user),
      appBar: AppBar(
        title: Text(
          'Estudiants ' + widget.aula.nombre,
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
                itemCount: _listaAlumnos.length,
                itemBuilder: (BuildContext context, index){
                  return ListTile(
                      title: Text(_listaAlumnos[index].nombre),
                      onTap: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Profile(widget.user,widget.aula, _listaAlumnos[index]))
                        );
                      },
                      onLongPress: (){
                        deleteAlumno(context, _listaAlumnos[index]);
                      },
                      trailing: Icon(Icons.arrow_forward_ios),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),)
                  );
                }),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                      addAlumno(context);
                  },
                  child: const Text('Afegir estudiant', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 5,
                  ),
                ),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context)=> CreaTest(widget.user, widget.aula))
                  );
                },
                child: const Text('Afegir nou Test', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  elevation: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget padding(Widget widget){
    return Padding(padding: EdgeInsets.all(7.0), child: widget);
  }


  Future<void> getListaAlumnos() async {
    http.Response response = await http.get(new Uri.http(apiURL, "/api/" + widget.user.email + "/clases/" + widget.aula.id.toString() + "/alumnos" ));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaAlumnos = data.map((model) => User.fromJson(model)).toList();
    });
  }

  Future<void> deleteAlumno(context, User alumno) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Eliminar alumne"),
          content: Text("Està segur que vol esborrar a " + alumno.nombre + " de la classe?"),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancelar")),
            TextButton(
                onPressed: () async {
                  await http.delete(new Uri.http(apiURL, "/api/" + widget.user.email + "/clases/" + widget.aula.id.toString() + "/" + alumno.email));
                  Navigator.pop(context);
                  setState(() {
                    getListaAlumnos();
                  });
                },
                child: Text("Esborrar", style: TextStyle(color: Colors.red),)),
          ],
        )
    );
  }
  Future<void> addAlumno(context) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Afegir estudiant"),
          content: TextFormField(
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            controller: controllerEmail,
            validator: (value) {
              if (value.isEmpty) {
                return 'No s\'ha escrit cap email.';
              }
              RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
              if(!regex.hasMatch(value)){
                return 'Format d\'email invalid.';
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
                  await http.put(new Uri.http(apiURL, "/api/" + widget.user.email + "/clases" ),
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode(<String, dynamic>{
                          'claseId': widget.aula.id,
                          'alumnoAssistenteEmail': controllerEmail.text}));
                  Navigator.pop(context);
                  setState(() {
                    getListaAlumnos();
                  });
                },
                child: Text("Afegir", style: TextStyle(color: Colors.green),)),
          ],
        )
    );
  }
}