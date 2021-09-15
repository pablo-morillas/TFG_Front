class Pregunta{
  String _respuesta1;
  String _respuesta2;
  String _respuesta3;
  String _respuestacorrecta;

  Pregunta({String respuesta1, String respuesta2, String respuesta3, String respuestacorrecta}){
    this._respuesta1 = respuesta1;
    this._respuesta2 = respuesta2;
    this._respuesta3 = respuesta3;
    this._respuestacorrecta = respuestacorrecta;
  }

  String get respuesta1 => _respuesta1;
  String get respuesta2 => _respuesta1;
  String get respuesta3 => _respuesta1;
  String get respuestacorrecta => _respuesta1;

  set respuesta1(String nombre) => _respuesta1 = respuesta1;
  set respuesta2(String nombre) => _respuesta2 = respuesta2;
  set respuesta3(String nombre) => _respuesta3 = respuesta3;
  set respuestacorrecta(String nombre) => _respuestacorrecta = respuestacorrecta;

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      respuesta1: json['id'],
      respuesta2: json['nombre'],
      respuesta3: json['preguntas'],
      respuestacorrecta: json["respuestacorrecta"],
    );
  }

}