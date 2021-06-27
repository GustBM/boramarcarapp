import 'package:boramarcarapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

// TODO: Checar ValueListenableBuilder pros dados de usuário
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final AppUser _userData = Provider.of<Auth>(context).getUserInfo;
    // final User _userInfo = Provider.of<Auth>(context).getUser;
    var _user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Row(
              children: [
                InkWell(
                  radius: 20.0,
                  onTap: () {
                    print('Click Profile Pic');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: (_user == null || _user.photoURL == null)
                        ? Image.asset(
                            'assets/images/standard_user_photo.png',
                            width: 40,
                          )
                        : Image.network(_user.photoURL!),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text((_user == null || _user.displayName == null
                    ? 'Bem-Vindo'
                    : _user.displayName)!),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Tela Inicial'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Novo Evento'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/new-event');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time_rounded),
            title: Text('Meu Horário'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/schedule');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/settings');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
