import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tfg/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:tfg/models/Informe.dart';
import 'package:tfg/models/User.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/screens/Informe/LoadingScreenInforme.dart';

import '../home.dart';


class VistaInforme extends StatefulWidget{

  VistaInforme(this.professor, this.estudiante, this.informe);

  User professor;
  User estudiante;
  Informe informe;

  @override
  _VistaInformeState createState() => _VistaInformeState();
}

class _VistaInformeState extends State<VistaInforme>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreenInforme(widget.estudiante))
            );
          },
        ),
        title: Text(
          "Informe del Professor " + widget.professor.nombre,
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
      ),
      body: buildForm()
    );
  }

  Widget buildForm() {
    return Scaffold(
      body: Padding(
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
                  buildTextAssistencia(widget.informe.notaAssistencia),
                  SizedBox(height: 20,),
                  Container(
                    child: Text(
                      "Atenci?? i participaci?? a classe",
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
                  buildTextAtencio(widget.informe.notaAtencio),

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
                  buildTextExercicis(widget.informe.notaExercicis),


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
                  buildTextTreball(widget.informe.notaTreball),


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

                  Text("Es un estudiant amb prous capacitats per enfrontar-se a diferents entorns, ent??n les explicacions amb facilitat i intenta transmetre els coneixements als seus companys",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,),
                ],
              ),
            ),
          )
      );
  }

  Widget buildTextAssistencia(int notaAssistencia) {
    if (notaAssistencia == 1){
      return Text("Falta frequentment a les classes sense justificaci??, hauria de mirar de corregir aquest comportament per tal "
          "de que pugui aprofitar les classes i no tingui problemes a l'hora de treballar amb els seus companys.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
    else if(notaAssistencia == 2){
      return Text("A vegades falta a classe de manera injustificada, per?? no de manera recurrent. De totes maneres hauria "
          "d'intentar que la seva assist??ncia fos m??s regular de manera que pugui aprofitar les classes.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
    else{
      return Text("Si falta a les classes nom??s ho fa de manera puntual i justificada.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
  }

  Widget buildTextAtencio(int notaAtencio) {
    if (notaAtencio == 1){
      return Text("No est?? atent en les explicacions i/o no t?? inter??s en participar a classe. Una part important en les "
          "classes ??s la participaci?? dels estudiants i animem a l'alumne a ser m??s participatiu.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
    else if(notaAtencio == 2){
      return Text("Est?? atent i participa a classe, encara que no de manera regular. Espero que mantingui aquestes ganes "
          "per participar a classe en el futur.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
    else{
      return Text("Frecuentment est?? atent i participa de manera activa per tal d'entendre les explicacions.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
  }

  Widget buildTextExercicis(int notaExercicis) {
    if (notaExercicis == 1){
      return Text("Fa els exercicis que es preparen per fer a casa de vegades o directament mai els fa. Els exercicis preparats"
          "son una eina molt ??til per complementar les classes i ??s important que es realitzin abans d'arribar a classe.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
    else if(notaExercicis == 2){
      return Text("Fa els exercicis sovint i porta en forma de preguntes aquells que no ha sabut fer. Encara que es pot millorar la const??ncia en aquest h??bit,"
          "??s un pas molt important el intentar aprendre dels exercicis que es realitzen a casa.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
    else{
      return Text("Sempre realitza els exercicis preparats i intenta extreure conclusions de tots ells per tal de millorar la seva comprensi??. ",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
  }


  Widget buildTextTreball(int notaTreball) {
    if (notaTreball == 1){
      return Text("No mostra motivaci?? en les classes i aix?? repercuteix en el seu rendiment.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
    else if(notaTreball == 2){
      return Text("T?? la suficient motivaci?? per fer un bon treball, encara que li costa concentrar-se a les classes.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
    else{
      return Text("T?? una bona motivaci?? i concentraci?? a les classes lo que li permet ser creatiu i aut??nom al enfrontar-se als exercicis.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,);
    }
  }


}