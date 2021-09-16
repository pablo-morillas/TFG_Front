import 'Pregunta.dart';

class Test{
  int _id;
  String _nombre;
  List<Pregunta> _preguntas;

  Test({int id, String nombre, List<Pregunta> preguntas}){
    this._id = id;
    this._nombre = nombre;
    this._preguntas = preguntas;
  }


  int get id => _id;
  String get nombre => _nombre;
  List<Pregunta> get preguntas => _preguntas;

  set nombre(String nombre) => _nombre = nombre;
  set preguntas(List<Pregunta> preguntas) => _preguntas = preguntas;
  set id(int id) => _id = id;

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'],
      nombre: json['nombre'],
      preguntas: json['preguntas'],
    );
  }
}