class TestResolt{
  Id _id;
  int _nota;
  String _nomTest;

  TestResolt({Id id, int nota , String nomTest}){
    this._id = id;
    this._nota = nota;
    this._nomTest = nomTest;
  }


  Id get id => _id;
  int get nota => _nota;
  String get nomTest => _nomTest;

  set nota(int nota) => _nota = nota;
  set id(Id id) => _id = id;
  set nomTest(String nomTest) => _nomTest = nomTest;

  factory TestResolt.fromJson(Map<String, dynamic> json) {
    return TestResolt(
      id: Id.fromJson(json['id']),
      nota: json['nota'],
      nomTest: json['nomTest'],
    );
  }
}
class Id {
  String _alumnoId;
  int _testId;

  Id({String alumnoId, int testId})
  {
    this._alumnoId = alumnoId;
    this._testId = testId;
  }

  String get alumnoId => _alumnoId;
  int get testId => _testId;

  factory Id.fromJson(Map<String, dynamic> json){
    return Id(
        alumnoId: json['alumnoId'],
        testId: json['testId'],
    );
  }
}