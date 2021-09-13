import 'package:tfg/models/User.dart';
import 'package:tfg/screens/user/login.dart';
import 'package:tfg/screens/user/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tfg/screens/home.dart';


class Menu extends StatefulWidget {
  Menu(this.user);
  User user;

  @override
  _MenuContent createState() => _MenuContent();
}

class _MenuContent extends State<Menu> {

  nLogIn() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn())
    );
  }

  nHome() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(widget.user))
    );
  }

  nProfile() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile(widget.user))

    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AppBar(
            title: Text(
              'CyberAware',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.user.nombre,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              widget.user.email,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
              radius: 75,
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inici'),
            onTap: () => nHome(),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
                'Perfil'),
            onTap: () => nProfile(),
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: Text('Logout',
                style: TextStyle(color: Colors.redAccent)),
            onTap: () => nLogIn(),
          ),
        ],
      ),
    );
  }
}