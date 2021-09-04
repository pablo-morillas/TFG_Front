import 'dart:convert';
import 'dart:io';

import 'package:tfg/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/screens/user/signup.dart';

import 'package:tfg/screens/home.dart';

import 'package:tfg/global/global.dart' as Global;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LogIn extends StatelessWidget {
  static const String _title = 'CyberAware';

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
          title: Text('CyberAware'),
          centerTitle: true,
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

  String title = 'CyberAware';

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>{
  final _formKey = GlobalKey<FormState>();
  var _responseCode, _token;
  final controllerEmail = new TextEditingController();
  final controllerPasswd = new TextEditingController();

  User user = new User();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15.0),
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: TextFormField(
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextFormField(
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: 'Contrasenya',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: controllerPasswd,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'No s\'ha escrit cap contrasenya.';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top:30.0, bottom: 20.0, left: 90.0, right: 90.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        login(controllerEmail.text, controllerPasswd.text).whenComplete(
                                () {
                              if(_responseCode != 201){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Credencials invàlides.'),
                                ));
                              }
                              else{
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => Home(user))
                                );
                              }
                            }
                        );
                      }

                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top:70.0, bottom: 5.0, left: 40.0, right: 40.0),
                child:Text(
                  'Encara no t\'has registrat? Crea el teu compte.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top:5.0, bottom: 20.0, left: 90.0, right: 90.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp())
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                    ),
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )
              ),
            ]
        )
    );
  }

  Future<void> login(String email, String password) async{
    http.Response response = await http.post(new Uri.http("cyberaware.pythonanywhere.com", "/api/authentication/login/"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password}));
    _responseCode = response.statusCode;
    var data = jsonDecode(response.body);
    user = User.fromJson(data['user']);
    user.token = data['access_token'];
  }

}