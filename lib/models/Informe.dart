import 'dart:convert';

class Informe{
  Id _id;
  int _notaExercicis;
  int _notaAssistencia;
  int _notaAtencio;
  int _notaTreball;
  String _valoracions;

  Informe({Id id, int notaExercicis, int notaAssistencia, int notaAtencio, int notaTreball, String valoracions}) {
    this._id = id;
    this._notaExercicis = notaExercicis;
    this._notaAssistencia = notaAssistencia;
    this._notaAtencio = notaAtencio;
    this._notaTreball = notaTreball;
    this._valoracions = valoracions;
  }

  Id get id => _id;
  int get notaExercicis => _notaExercicis;
  int get notaAssistencia => _notaAssistencia;
  int get notaTreball => _notaTreball;
  int get notaAtencio => _notaAtencio;
  String get valoracions => _valoracions;

  factory Informe.fromJson(Map<String, dynamic> json){
    return Informe(
      id: Id.fromJson(json['id']),
      notaAssistencia: json['notaAssistencia'],
      notaExercicis: json['notaExercicis'],
      notaAtencio: json['notaAtencio'],
      notaTreball: json['notaTreball'],
      valoracions: json['valoracions']
    );
  }

}
class Id {
  String _estudiant;
  String _professor;
  DateTime _fecha;

  Id({String estudiant, String professor, DateTime fecha})
  {
    this._estudiant = estudiant;
    this._professor = professor;
    this._fecha = fecha;
  }

  String get estudiant => _estudiant;
  String get professor => _professor;
  DateTime get fecha => _fecha;

  factory Id.fromJson(Map<String, dynamic> json){
    return Id(
      estudiant: json['estudiantId'],
      professor: json['professorId'],
      fecha: DateTime.parse(json['fecha'])
    );
  }
}