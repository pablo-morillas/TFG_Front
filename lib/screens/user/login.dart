import 'dart:convert';
import 'dart:io';

import 'package:tfg/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/screens/user/signup.dart';

import 'package:tfg/screens/home.dart';

import 'package:tfg/global/global.dart';
import 'package:http/http.dart' as http;


class LogIn extends StatelessWidget {
  static const String _title = 'TFG';

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
          title: Text('TFG'),
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

  String title = 'TFG';

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
  Widget build (BuildContext context){
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Icon(Icons.person_outlined, color: Colors.grey[300], size: 140),
                  SizedBox(height: 13),
                  Text(
                    "Benvingut",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Inicia sessió per continuar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400]
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: TextFormField(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
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
                  Container(
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
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
                      controller: controllerPasswd,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'No s\'ha escrit cap contrasenya.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 50,),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          login(controllerEmail.text, controllerPasswd.text).whenComplete(
                                  () {
                                if(_responseCode != 200){
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
                        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        )
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No tens un compte? ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp())
                          );
                        },
                        child: Text(
                          "Registra\'t",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
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

    print(user.userRole);
  }
}