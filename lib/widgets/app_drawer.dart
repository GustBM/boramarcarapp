import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../utils.dart' as utils;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? _user;

    Future<void> getUser() async {
      _user = FirebaseAuth.instance.currentUser;
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: FutureBuilder(
              future: getUser(),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('Houve um Erro'),
                  );
                } else {
                  return Row(
                    children: [
                      ClipOval(
                        child: (_user == null || _user!.photoURL == null)
                            ? Image.asset(
                                'assets/images/standard_user_photo.png',
                                width: 35,
                              )
                            : Image.network(
                                _user!.photoURL!,
                                width: 35,
                              ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                            (_user == null || _user!.displayName == null
                                ? 'Bem-Vindo'
                                : _user!.displayName)!,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  );
                }
              },
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
            leading: Icon(Icons.group),
            title: Text('Grupos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/groups');
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
              utils.showConfirmDialog(context, '', 'Deseja sair do BoraMarcar?',
                  () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              });
            },
          ),
        ],
      ),
    );
  }
}
