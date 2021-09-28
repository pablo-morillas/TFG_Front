import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tfg/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:tfg/models/Aula.dart';
import 'package:tfg/models/Pregunta.dart';
import 'package:tfg/models/User.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../home.dart';



class CreaTest extends StatefulWidget{

  CreaTest(this.user, this.aula);
  User user;
  Aula aula;

  @override
  _CreaTestState createState() => _CreaTestState();

}

class _CreaTestState extends State<CreaTest> {

  var _numRespuestas = 2;
  List<Pregunta> _listaPreguntas = new List.filled(10, Pregunta());
  var _preguntaSeleccionada = 0;

  final _formKey2 = GlobalKey<FormState>();
  var _controllerText = new TextEditingController();
  var _controllerRespostaCorrecta = new TextEditingController();
  var _controllerResposta1 = new TextEditingController();
  var _controllerResposta2 = new TextEditingController();
  var _controllerResposta3 = new TextEditingController();

  PageController _controller = PageController(initialPage: 0, keepPage: false);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home(widget.user))
            );
          },
        ),
        title: Text(
          "Afegir pregunta",
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.blue],
                begin: Alignment.bottomRight,
                end: Alignment.topRight,
              )
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Container(
                height: 50,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index){
                      return ElevatedButton(
                          onPressed: () {  },
                          style: ElevatedButton.styleFrom(
                            primary: _preguntaSeleccionada == index ? Colors.orange.shade300 : Colors.white,
                            shape: CircleBorder(),
                          ),
                          child: Text(
                            (index+1).toString(),
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          )
                      );
                    },
                    separatorBuilder: (context, index)=> Container(width: 16,),
                    itemCount: _listaPreguntas.length)
            ),
          ),
        ),
      ),
      body: PageView.builder(
        onPageChanged: (page){
          setState(() {
            _preguntaSeleccionada = page.toInt();
          });
        },
        controller: _controller,
        itemCount: _listaPreguntas.length,
        itemBuilder: (context, index){
          return buildForm();
        },
      ),
    );
  }

  Widget buildForm() {

    return Scaffold(
        body: Form(
          key: _formKey2,
          child: Padding(
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      child: TextFormField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Pregunta",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _controllerText,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'No s\'ha escrit cap email.';
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
                            suffixIcon: Icon(Icons.question_answer, color: Colors.green,),
                            labelText: "Resposta Correcta",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _controllerRespostaCorrecta,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'No s\'ha escrit Resposta.';
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
                            suffixIcon: Icon(Icons.question_answer, color: Colors.red,),
                            labelText: "Resposta Incorrecta",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        controller: _controllerResposta1,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'No s\'ha escrit resposta.';
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
                            suffixIcon: Icon(Icons.question_answer, color: Colors.red,),
                            labelText: "Resposta Incorrecta",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        controller: _controllerResposta2,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'No s\'ha escrit resposta.';
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
                            suffixIcon: Icon(Icons.question_answer, color: Colors.red,),
                            labelText: "Resposta Incorrecta",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            )
                        ),
                        controller: _controllerResposta3,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'No s\'ha escrit cap resposta.';
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
                          if (_formKey2.currentState.validate()) {
                            if (_preguntaSeleccionada+1 == 10) {
                              setState(() {
                                onTapPage(_preguntaSeleccionada+1);
                              });
                              enviaTestPreguntes(_listaPreguntas);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home(widget.user))
                              );
                            }
                            else {
                              ++_preguntaSeleccionada;
                              setState(() {
                                onTapPage(_preguntaSeleccionada);
                              });
                            }
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
                          'Següent Pregunta',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                )
                ),
              ),
            ),
          ),
        );
  }

  void onTapPage(int index) {
      _listaPreguntas[index - 1] = new Pregunta(
          text: _controllerText.text,
          respuestacorrecta: _controllerRespostaCorrecta.text,
          respuesta1: _controllerResposta1.text,
          respuesta2: _controllerResposta2.text,
          respuesta3: _controllerResposta3.text
      );
      var variable = _preguntaSeleccionada.toString();
      var variable2 = index.toString();

      print("AQUI DIGO LA PAGINA: $variable");
      print("AQUI DIGO EL INDEX: $variable2");

      print("AQUI DIGO EL TEXTO DE LA PREGUNTA: " +
          _listaPreguntas[index - 1].text);
      print("AQUI DIGO LA RESPUESTA CORRECTA: " +
          _listaPreguntas[index - 1].respuestacorrecta);
      print("AQUI DIGO EL RESPUESTA INCORRECTA 1: " +
          _listaPreguntas[index - 1].respuesta1);
      print("AQUI DIGO EL RESPUESTA INCORRECTA 2: " +
          _listaPreguntas[index - 1].respuesta2);
      print("AQUI DIGO EL RESPUESTA INCORRECTA 3: " +
          _listaPreguntas[index - 1].respuesta3);

    _controllerText = new TextEditingController();
    _controllerRespostaCorrecta = new TextEditingController();
    _controllerResposta1 = new TextEditingController();
    _controllerResposta2 = new TextEditingController();
    _controllerResposta3 = new TextEditingController();
    _controller.jumpToPage(index);
  }

  Future<void> enviaTestPreguntes(List<Pregunta> listaPreguntas) async {
    http.Response response = await http.post(new Uri.http(apiURL, "/api/" + widget.user.email + "/"+ widget.aula.id.toString() + "/tests"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'nombre': "test numero 2",
        }));
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    var idTest = data['id'];
    print(idTest);

    for(var index = 0; index < _listaPreguntas.length; ++index){
      print(_listaPreguntas[index].text);
      http.Response response = await http.post(new Uri.http(apiURL, "/api/" + widget.user.email + "/8/"+ idTest.toString()),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'text': _listaPreguntas[index].text,
            'respuestaCorrecta':  _listaPreguntas[index].respuestacorrecta,
            'respuestaIncorrecta1': _listaPreguntas[index].respuesta1,
            'respuestaIncorrecta2': _listaPreguntas[index].respuesta2,
            'respuestaIncorrecta3': _listaPreguntas[index].respuesta3,
          }));
    }
  }
}