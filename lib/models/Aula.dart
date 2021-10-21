import 'package:tfg/models/User.dart';

class Aula{
  int _id;
  String _nombre;
  User _profesor;

  Aula({int id, String nombre, User profesor}){
    this._id = id;
    this._nombre = nombre;
    this._profesor = profesor;
  }


  int get id => _id;
  String get nombre => _nombre;
  User get profesor => _profesor;

  set nombre(String nombre) => _nombre = nombre;
  set profesor(User profesor) => _profesor = profesor;
  set id(int id) => _id = id;

  factory Aula.fromJson(Map<String, dynamic> json) {
    return Aula(
      id: json['id'],
      nombre: json['nombre'],
      profesor: User.fromJson(json['profesor']),
    );
  }
}