import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tfg/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:tfg/models/User.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../home.dart';


class CreaInforme extends StatefulWidget{

  CreaInforme(this.user, this.estudiante);

  User user;
  User estudiante;

  @override
  _CreaInformeState createState() => _CreaInformeState();
}

class _CreaInformeState extends State<CreaInforme>{
  var _controllerText = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Declare this variable
  int selectedRadioTileAssistencia;
  int selectedRadioTileAtencio;
  int selectedRadioTileExercicis;
  int selectedRadioTileTreball;

  @override
  void initState() {
    selectedRadioTileAssistencia = 0;
    selectedRadioTileAtencio = 0;
    selectedRadioTileExercicis = 0;
    selectedRadioTileTreball = 0;
  }

  setSelectedRadioTileAssistencia(int val) {
    setState(() {
      selectedRadioTileAssistencia = val;
    });
  }

  setSelectedRadioTileAtencio(int val) {
    setState(() {
      selectedRadioTileAtencio = val;
    });
  }

  setSelectedRadioTileExercicis(int val) {
    setState(() {
      selectedRadioTileExercicis = val;
    });
  }

  setSelectedRadioTileTreball(int val) {
    setState(() {
      selectedRadioTileTreball = val;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nou Informe " + widget.estudiante.nombre,
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
      ),
      body: buildForm()
    );
  }

  Widget buildForm() {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Assistencia a classe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Divider(
                    height: 20,
                    color: Colors.green,
                  ),

                  RadioListTile(
                    value: 1,
                    groupValue: selectedRadioTileAssistencia,
                    title: Text("Assistència irregular"),
                    subtitle: Text("Falta frequentment a les classes sense justificació"),
                    onChanged: (val) {
                      setSelectedRadioTileAssistencia(val);
                    },
                    activeColor: Colors.red,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: selectedRadioTileAssistencia,
                    title: Text("Assistència millorable"),
                    subtitle: Text("A vegades falta a classe de manera injustificada, però no de manera recurrent"),
                    onChanged: (val) {
                      setSelectedRadioTileAssistencia(val);
                    },
                    activeColor: Colors.blue,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: selectedRadioTileAssistencia,
                    title: Text("Bona assistència"),
                    subtitle: Text("Si falta a les classes només ho fa de manera puntual i justificada"),
                    onChanged: (val) {
                      setSelectedRadioTileAssistencia(val);
                    },
                    activeColor: Colors.green,
                    selected: false,
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: Text(
                      "Atenció i participació a classe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Divider(
                    height: 20,
                    color: Colors.green,
                  ),

                  RadioListTile(
                    value: 1,
                    groupValue: selectedRadioTileAtencio,
                    title: Text("Poca atenció i/o participació"),
                    subtitle: Text("No està atent en les explicacions i/o no té interés en participar a classe"),
                    onChanged: (val) {
                      setSelectedRadioTileAtencio(val);
                    },
                    activeColor: Colors.red,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: selectedRadioTileAtencio,
                    title: Text("Atenció i participació suficients"),
                    subtitle: Text("Està atent i participa a classe, encara que no de manera regular"),
                    onChanged: (val) {
                      setSelectedRadioTileAtencio(val);
                    },
                    activeColor: Colors.blue,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: selectedRadioTileAtencio,
                    title: Text("Bona atenció i participació"),
                    subtitle: Text("Frecuentment està atent i participa de manera activa per tal d'entendre les explicacions"),
                    onChanged: (val) {
                      setSelectedRadioTileAtencio(val);
                    },
                    activeColor: Colors.green,
                    selected: false,
                  ),

                  SizedBox(height: 20,),
                  Container(
                    child: Text(
                      "Exercicis i deures a casa",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Divider(
                    height: 20,
                    color: Colors.green,
                  ),

                  RadioListTile(
                    value: 1,
                    groupValue: selectedRadioTileExercicis,
                    title: Text("Disciplina irregular"),
                    subtitle: Text("Fa els exercicis que es preparen per fer a casa de vegades o directament mai els fa"),
                    onChanged: (val) {
                      setSelectedRadioTileExercicis(val);
                    },
                    activeColor: Colors.red,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: selectedRadioTileExercicis,
                    title: Text("Bona disciplina"),
                    subtitle: Text("Fa els exercicis sovint i porta en forma de preguntes aquells que no ha sabut fer"),
                    onChanged: (val) {
                      setSelectedRadioTileExercicis(val);
                    },
                    activeColor: Colors.blue,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: selectedRadioTileExercicis,
                    title: Text("Disciplina exemplar"),
                    subtitle: Text("Sempre realitza els exercicis preparats i intenta extreure conclusions de tots ells per tal de millorar la seva comprensió"),
                    onChanged: (val) {
                      setSelectedRadioTileExercicis(val);
                    },
                    activeColor: Colors.green,
                    selected: false,
                  ),

                  SizedBox(height: 20,),
                  Container(
                    child: Text(
                      "Manera de treballar",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Divider(
                    height: 20,
                    color: Colors.green,
                  ),

                  RadioListTile(
                    value: 1,
                    groupValue: selectedRadioTileTreball,
                    title: Text("Poca motivació"),
                    subtitle: Text("No mostra motivació en les classes i això repercuteix en el seu rendiment"),
                    onChanged: (val) {
                      setSelectedRadioTileTreball(val);
                    },
                    activeColor: Colors.red,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: selectedRadioTileTreball,
                    title: Text("Bona motivació i poca concentració"),
                    subtitle: Text("Té la suficient motivació per fer un bon treball, encara que li costa concentrar-se a les classes"),
                    onChanged: (val) {
                      setSelectedRadioTileTreball(val);
                    },
                    activeColor: Colors.blue,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: selectedRadioTileTreball,
                    title: Text("Bona motivació i concentració"),
                    subtitle: Text("Té una bona motivació i concentració a les classes lo que li permet ser creatiu i autònom al enfrontar-se als exercicis"),
                    onChanged: (val) {
                      setSelectedRadioTileTreball(val);
                    },
                    activeColor: Colors.green,
                    selected: false,
                  ),

                  SizedBox(height: 20,),
                  Container(
                    child: Text(
                      "Valoracions i comentaris",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Divider(
                    height: 20,
                    color: Colors.green,
                  ),

                  TextField(
                    controller: _controllerText,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintText: "Escriu aquí les teves valoracions i observacions",
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w800,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.green),
                          borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.green),
                          borderRadius: BorderRadius.circular(15),
                      ),
                  ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(_controllerText.text == "" || selectedRadioTileTreball == 0 || selectedRadioTileExercicis == 0 || selectedRadioTileAtencio == 0 || selectedRadioTileAssistencia == 0){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('No has omplert tots els camps necessaris'),
                        ));
                      }
                      else {
                        addInforme();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home(widget.user))
                        );
                      }
                    }, 
                    child: Text(
                      "Crear informe"
                    ),
                  )
                ],
              ),
            ),
          )
      )
    );
  }
  
  void addInforme() async {
    String fecha = new DateTime.now().toString().substring(10);
    print(fecha);

    await http.post(new Uri.http(apiURL, "/api/informes/"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': widget.user.token,
        },
        body: jsonEncode({
          'id': {
            'estudiantId': widget.estudiante.email,
            'professorId': widget.user.email,
            'fecha': fecha,
          },
          'notaExercicis': selectedRadioTileExercicis,
          'notaAtencio': selectedRadioTileAtencio,
          'notaAssistencia': selectedRadioTileAssistencia,
          'notaTreball': selectedRadioTileTreball,
          'valoracions': _controllerText.text
        }));
  }

}