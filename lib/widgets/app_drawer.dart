import 'package:boramarcarapp/view/event/event_new_screen.dart';
import 'package:boramarcarapp/view/group/groups_screen.dart';
import 'package:boramarcarapp/view/home_screen.dart';
import 'package:boramarcarapp/view/schedule/schedule_screen.dart';
import 'package:boramarcarapp/view/settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
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
          DrawerItem(
            icon: Icons.home_filled,
            title: 'Tela Inicial',
            path: HomeScreen.routeName,
          ),
          DrawerItem(
            icon: Icons.event,
            title: 'Novo Evento',
            path: EventFormScreen.routeName,
          ),
          DrawerItem(
            icon: Icons.access_time_rounded,
            title: 'Meu Hor??rio',
            path: SchedueleScreen.routeName,
          ),
          DrawerItem(
            icon: Icons.group,
            title: 'Grupos',
            path: GroupsScreen.routeName,
          ),
          DrawerItem(
            icon: Icons.settings,
            title: 'Configura????es',
            path: SettingsScreen.routeName,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout',
                style: TextStyle(fontSize: 18, fontFamily: 'Lato')),
            onTap: () {
              utils.showConfirmDialog(context, '', 'Deseja sair do BoraMarcar?',
                  () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<AuthController>(context, listen: false).logout();
              });
            },
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String path;

  DrawerItem({required this.icon, required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Lato'),
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(path);
          },
        ),
      ],
    );
  }
}
