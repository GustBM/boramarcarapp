import 'package:boramarcarapp/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  Widget buildListTile(
      String title, IconData icon, String pageAddress, BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 26),
          title: Text(title),
          onTap: () => {
            Navigator.of(context).pushNamed('/' + pageAddress),
          },
        ),
        listDivider,
      ],
    );
  }

  final Widget listDivider = Divider(
    thickness: 1,
    indent: 8,
    endIndent: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            buildListTile(
                'Editar Informações', Icons.person, 'edit-user', context),
            buildListTile('Mudar Senha', Icons.lock, 'edit-user', context),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_view_month, size: 26),
                  title: Text('Reiniciar Horário'),
                  onTap: () {
                    showConfirmDialog(context, 'Reiniciar Horário',
                        'Deseja Reiniciar Horário?', () {
                      try {
                        Provider.of<Auth>(context, listen: false)
                            .addNewUserSchedule(
                                FirebaseAuth.instance.currentUser!.uid);
                      } on Exception catch (e) {
                        showErrorDialog(
                            context,
                            ' [' +
                                e.toString() +
                                '] Houve um Erro, Tente Novamente');
                      } finally {
                        SnapshotEmptyMsg('Horário Atualizado');
                        Navigator.pop(context);
                      }
                    });
                  },
                ),
                listDivider,
              ],
            ),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.exit_to_app, size: 26),
                  title: Text('Sair'),
                  onTap: () {
                    // Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                ),
                listDivider,
              ],
            ),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info, size: 26),
                  title: Text('Sobre'),
                  onTap: () {
                    showAboutDialog(context: context);
                  },
                ),
                listDivider,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
