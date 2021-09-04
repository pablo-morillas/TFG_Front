class User {
  String _username;
  String _email;
  String _name;
  String _token;


  User({String username, String email, String name, String token})
  {
    this._username = username;
    this._email = email;
    this._name = name;
    this._token = token;

  }

  String get username => _username;
  String get email => _email;
  String get name => _name;
  String get token => _token;

  set username(String username) => _username = username;
  set email(String email) => _email = email;
  set name(String name) => _name = name;
  set token(String token) => _token = token;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      name: json['name'],
    );
  }
}