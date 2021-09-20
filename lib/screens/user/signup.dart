import 'dart:convert';

import 'package:tfg/global/global.dart';
import 'package:tfg/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../home.dart';
import 'login.dart';

class SignUp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode actualFocus = FocusScope.of(context);

        if(!actualFocus.hasPrimaryFocus){
          actualFocus.unfocus();
        }
      },

      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn())
              );
            },
          ),
          title: Text('Sign Up'),
        ),
        body: Stack(
            children: <Widget>[
              Center(
                child: MyStatefulWidget(),
              )
            ]
        ),),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  String title = 'TFG';

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>{

  final _formKey = GlobalKey<FormState>();
  var _responseCode, _token;
  List<String> responseError = [];
  final _controllerEmail = new TextEditingController();
  final _controllerPasswd = new TextEditingController();
  final _controllerPasswdConfirm = new TextEditingController();
  final _controllerNombre = new TextEditingController();
  var _controllerUserRole = new TextEditingController();

  List<String> listOfValue = ['alumne', 'professor'];


  User user = new User();

  @override
  void initState() {
    List<String> responseError = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Icon(Icons.person_outlined, color: Colors.grey[300], size: 90),
                    SizedBox(height: 13),
                    Text(
                      "Crear Compte",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Crea un nou compte per continuar",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400]
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.mail),
                            labelText: "EMAIL",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _controllerEmail,
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
                    ),
                    Container(
                      child: TextFormField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person_outlined),
                            labelText: "Nom i cognoms",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _controllerNombre,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'No s\'ha escrit cap Nom i cognoms.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        obscureText: true,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock),
                            labelText: "Contrasenya",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        controller: _controllerPasswd,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'No s\'ha escrit cap contrasenya.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        obscureText: true,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock),
                            labelText: "Confirma contrasenya",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        controller: _controllerPasswdConfirm,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'No s\'ha escrit la confirmació de contrasenya.';
                          }
                          if(value != _controllerPasswd.text){
                            return 'Les contrasenyes no coincideixen';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: DropdownButtonFormField(
                        style: TextStyle(
                            color: Colors.black
                        ),
                        decoration: InputDecoration(
                          labelText: 'Tipus d\'usuari',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        items: listOfValue.map((String val){
                          return DropdownMenuItem(
                              value: val,
                              child: Text(val)
                          );
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            _controllerUserRole.text = value;
                          });
                        },
                        validator: (value) => value == null
                            ? 'No s\'ha seleccionat cap tipus d\'usuari.' : null,
                      ),

                    ),
                    SizedBox(height: 50,),
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            signUp().whenComplete(() {
                              if(_responseCode != 201){
                                return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Registre incorrecte.')));
                              }
                              else{
                                login(_controllerEmail.text, _controllerPasswd.text).whenComplete(() {
                                  if(_responseCode == 200){
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => Home(user))
                                    );
                                  }
                                });

                              }
                            });
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            )
                        ),
                        child: Text(
                          'Crear Compte',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }



  Future<void> signUp() async{
    http.Response response = await http.post(new Uri.http(apiURL, "/api/usuarios/"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'nombre': _controllerNombre.text,
          'email': _controllerEmail.text,
          'password': _controllerPasswd.text,
          'userRole': _controllerUserRole.text,
        }));
    _responseCode = response.statusCode;
    print(_responseCode);
    if (_responseCode != 201){
      Map<String, dynamic> data = jsonDecode(response.body);
      responseError=[];
      for (var name in data.keys){
        responseError.add(name);
      }
    }
  }

  Future<void> login(String email, String password) async{
    http.Response response = await http.post(new Uri.http(apiURL, "/api/usuarios/login"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password}));
    _responseCode = response.statusCode;
    _token = response.headers['authorization'].toString();


    final response2 = await http.get(new Uri.http(apiURL, "/api/usuarios/"+email));
    user = User.fromJson(jsonDecode(response2.body));
    user.token = _token;

  }
}