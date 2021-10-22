import 'dart:convert';
import 'dart:io';

import 'package:tfg/global/global.dart';
import 'package:tfg/models/TestResolt.dart';
import 'package:tfg/models/User.dart';
import 'package:tfg/screens/menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget{
  MyProfile(this.user);
  User user;

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>{

  List<dynamic> _listaTests = [];

  final _formKey = GlobalKey<FormState>();

  final _controllerText = TextEditingController();
  var _token;

  @override
  List<dynamic> initState() {
    getListaTests();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Menu(widget.user),
      appBar: AppBar(
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
                showDialog(context: context, builder: (context){
                  _controllerText.text = "";
                  return AlertDialog(
                      title: Text('Escriu els camps que vols editar.',
                        style: TextStyle(fontSize: 24),),
                      content: Form(
                        key: _formKey,
                        child: Container(
                          height: 170,
                          child: Column(
                            children: [
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Nom i cognoms',
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: _controllerText,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'No s\'ha escrit cap informacio.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                height: 50,
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: (){
                                    if(_formKey.currentState.validate()){
                                      update(_controllerText.text).whenComplete(() => Navigator.pop(context));
                                    }
                                  },
                                  child: Text(
                                    'Actualitzar',
                                    style: TextStyle(fontSize: 18),),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  );
                });
              },
              icon: Icon(Icons.edit)),
        ],
      ),
      body: vistaPerfil(),
    );
  }



  Widget vistaPerfil(){
    if(widget.user.userRole == "professor"){
      return Column(
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
                  widget.user.nombre,
                  style: TextStyle(
                    fontSize: 20,
                  )
              ),
              ),
            ),
            ListTile(
              title: Center(child: Text(
                  widget.user.email,
                  style: TextStyle(
                    fontSize: 16,
                  )
              ),
              ),
            )
          ]
      );
    }
    else{
      return Column(
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
                  widget.user.nombre,
                  style: TextStyle(
                    fontSize: 20,
                  )
              ),
              ),
            ),
            ListTile(
              title: Center(child: Text(
                  widget.user.email,
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
      );
    }
}

  Future<void> update(String nombre) async{
    http.Response response = await http.put(new Uri.http(apiURL, "/api/usuarios/" +  widget.user.email),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': widget.user.token,
        },
        body: jsonEncode({
          'nombre': nombre,
        }));
    print(response.statusCode);
    var data = jsonDecode(response.body);
    print(data);
    setState(() {
      _token = widget.user.token;
      widget.user = User.fromJson(data);
      widget.user.token = _token;
    });

  }

  Future<void> getListaTests() async {

    http.Response response = await http.get(new Uri.http(apiURL, "/api/usuarios/" + widget.user.email + "/examenresolts" ));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaTests = data.map((model) => TestResolt.fromJson(model)).toList();
    });

    print(_listaTests);
  }


}