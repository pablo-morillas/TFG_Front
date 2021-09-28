class Pregunta{
  String _text;
  String _respuesta1;
  String _respuesta2;
  String _respuesta3;
  String _respuestacorrecta;
  List<String> _listarespuestas;

  Pregunta({String text, String respuesta1, String respuesta2, String respuesta3, String respuestacorrecta}){
    this._text = text;
    this._respuesta1 = respuesta1;
    this._respuesta2 = respuesta2;
    this._respuesta3 = respuesta3;
    this._respuestacorrecta = respuestacorrecta;
    this._listarespuestas = [_respuesta1, _respuesta2, _respuesta3, _respuestacorrecta];
    this._listarespuestas.shuffle();
  }

  String get text => _text;
  String get respuesta1 => _respuesta1;
  String get respuesta2 => _respuesta2;
  String get respuesta3 => _respuesta3;
  String get respuestacorrecta => _respuestacorrecta;
  List<String> get listaRespuestas => _listarespuestas;

  set respuesta1(String respuesta1) => _respuesta1 = respuesta1;
  set respuesta2(String respuesta2) => _respuesta2 = respuesta2;
  set respuesta3(String respuesta3) => _respuesta3 = respuesta3;
  set respuestacorrecta(String respuestacorrecta) => _respuestacorrecta = respuestacorrecta;
  set listaRespuestas(List<String> listarespuestas) => _listarespuestas = listarespuestas;

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      text: json['textoPregunta'],
      respuesta1: json['respuestaIncorrecta1'],
      respuesta2: json['respuestaIncorrecta2'],
      respuesta3: json['respuestaIncorrecta3'],
      respuestacorrecta: json["respuestaCorrecta"],
    );
  }

}