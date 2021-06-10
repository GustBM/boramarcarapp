import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  Widget buildListTile(
      String title, IconData icon, Function linkHandler, BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 26),
          title: Text(title),
          onTap: () => {
            // Navigator.of(context).pop(),
            // Navigator.of(context).pushReplacementNamed('/'),
            linkHandler
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
            buildListTile('Editar Informações', Icons.person, null, context),
            /*buildListTile('Sair', Icons.exit_to_app,
                Provider.of<Auth>(context, listen: false).logout, context),*/
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
