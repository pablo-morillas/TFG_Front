import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/global/global.dart';
import 'package:tfg/models/Pregunta.dart';
import 'package:tfg/screens/LoadingScreen.dart';
import '../../models/Aula.dart';
import '../../models/Test.dart';
import '../../models/User.dart';
import '../home.dart';

class Quiz extends StatefulWidget{

  Quiz(this.user, this.aula, this.test);
  User user;
  Aula aula;
  Test test;


  @override
  _quizState createState() => _quizState();
}

class _quizState extends State<Quiz>{

  List<dynamic> _listaPreguntas = [];

  int _puntuacion = 0;
  List<String> _arrayRespuestas;
  String _respuestaSeleccionada;
  List<String> _respuestaCorrecta;
  Future<void> _getPreguntas;
  int _preguntaSeleccionada;
  bool respondida = false;

  PageController _controller;

  @override
  List<dynamic> initState() {
    _puntuacion = 0;
    _controller = PageController(initialPage: 0, keepPage: false);
    //Poner cualquier respuesta para inicializar
    _respuestaSeleccionada = "Cualquier frase que indique que esta no será la respuesta";
    _getPreguntas = getListaPreguntas().whenComplete((){
      _respuestaCorrecta = new List.filled(_listaPreguntas.length, "Cualquier frase que indique que esta no será la respuesta");
      _arrayRespuestas = new List.filled(_listaPreguntas.length, _respuestaSeleccionada);
    });
    _preguntaSeleccionada = 0;
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);

    return FutureBuilder<void>(
      future: _getPreguntas,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot){
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.test.nombre,
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
                          onPressed: (){
                            onTapPage(index);
                            setState(() {
                              _preguntaSeleccionada = index;
                            });
                          },
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
              final question = _listaPreguntas[index];

              return buildPregunta(pregunta: question, index_pregunta: index);
            },
          ),
        );
      }
    );
  }
  Widget buildPregunta({Pregunta pregunta, int index_pregunta}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15 ),
                Text(
                  pregunta.text,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Text(
                  'Escull una sola opció.',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: buildOptions(pregunta: pregunta, index_pregunta: index_pregunta),
                ),
                (_respuestaCorrecta[index_pregunta]!="Cualquier frase que indique que esta no será la respuesta") ? Container(
                    height: 90,
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: (){
                          if (index_pregunta == _listaPreguntas.length-1){
                            //pushResultado();
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                  title: Text('Has acabat la formació.',
                                    style: TextStyle(fontSize: 24),),
                                  content: Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('La teva puntuació ha estat: ',
                                              style: TextStyle(fontSize: 16),),
                                            SizedBox(height: 100, width: 20,),
                                            Text(_puntuacion.toString(),
                                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: (){
                                            //addPuntuacio().whenComplete(() =>
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => LoadingScreen(widget.user, _puntuacion))
                                            );
                                          },
                                          child: Text('Tornar al menu principal'),
                                        )
                                      ],
                                    ),
                                  )
                              );
                            });
                          }else{
                            onTapPage(index_pregunta+1);
                            setState(() {
                              _preguntaSeleccionada = index_pregunta+1;
                            });
                          }
                        },
                        child: (index_pregunta == _listaPreguntas.length-1) ? Text('Envia') : Icon(Icons.arrow_forward),
                      ),
                    )
                ) : Container()
              ]

          ),

        )
    );
  }


  Widget buildOptions({Pregunta pregunta, int index_pregunta}) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10,);
        },
        itemCount: pregunta.listaRespuestas.length,
        itemBuilder: (context, index){
          return TextButton(
            onPressed: () {
              print(_respuestaCorrecta);
              print(pregunta.respuestacorrecta);
              if (_respuestaCorrecta[index_pregunta] == "Cualquier frase que indique que esta no será la respuesta") {
                if (pregunta.listaRespuestas[index] == pregunta.respuestacorrecta) {
                  _puntuacion += 10;
                  print(_puntuacion);
                }
                setState(() {
                  _respuestaCorrecta[index_pregunta] = pregunta.respuestacorrecta;
                  _respuestaSeleccionada = pregunta.listaRespuestas[index];
                  _arrayRespuestas[index_pregunta] = _respuestaSeleccionada;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_respuestaCorrecta[index_pregunta]==pregunta.listaRespuestas[index]) ? Colors.green : getColorCorrecto(pregunta.listaRespuestas[index], index_pregunta),
                borderRadius: BorderRadius.circular(16),
              ),
              child: (_respuestaCorrecta[index_pregunta] == pregunta.listaRespuestas[index]) ?
              Column(
                children: [
                  buildAnswer(pregunta.listaRespuestas[index]),
                ],
              ):
              Column(
                children: [
                  buildAnswer(pregunta.listaRespuestas[index]),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget buildAnswer(String respuesta){
    return Container(

      child: Container(child:
        Text(
          respuesta,
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
       )
      ),
    );
  }



  Future<void> getListaPreguntas() async {
    http.Response response = await http.get(new Uri.http(apiURL, "/api/" + widget.user.email + "/" + widget.aula.id.toString() + "/"+ widget.test.id.toString() + "/preguntas"));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    setState((){
      _listaPreguntas = data.map((model) => Pregunta.fromJson(model)).toList();
    });
  }

  void onTapPage(int index) {
    _controller.jumpToPage(index);
  }

  Color getColorCorrecto(String respuesta, int index_pregunta) {
    bool _seleccionada = (_respuestaSeleccionada == respuesta);
    bool _apretada = (_arrayRespuestas[index_pregunta] == respuesta);

    if(_seleccionada || _apretada){
      if(_respuestaCorrecta[index_pregunta] == respuesta){
        return Colors.green;
      }else{
        return Colors.red;
      }

    }else{
      return Colors.grey.shade200;
    }
  }

  Future<void> addPuntuacio() async {
    await http.put(new Uri.http(apiURL, "/api/usuarios/" + widget.user.email + "/puntos"),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': widget.user.token,
    },
    body: jsonEncode(<String, String>{
      'email': widget.user.email,
    'puntos': _puntuacion.toString(),
    }));


  }

}
