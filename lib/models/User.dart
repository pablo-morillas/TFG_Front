class User {
  String _username;
  String _email;
  String _nombre;
  String _token;
  String _userRole;


  User({String username, String email, String nombre, String token, String userRole})
  {
    this._username = username;
    this._email = email;
    this._nombre = nombre;
    this._token = token;
    this._userRole = userRole;

  }

  String get username => _username;
  String get email => _email;
  String get nombre => _nombre;
  String get token => _token;
  String get userRole => _userRole;

  set username(String username) => _username = username;
  set email(String email) => _email = email;
  set name(String nombre) => _nombre = nombre;
  set token(String token) => _token = token;
  set userRole(String userRole) => _userRole = userRole;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      nombre: json['nombre'],
      userRole: json['userRole'],
    );
  }
}