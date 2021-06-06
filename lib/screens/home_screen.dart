import 'package:boramarcarapp/widgets/event/event_grid.dart';
import 'package:flutter/material.dart';

import 'package:boramarcarapp/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-Vindo'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          EventGrid(),
        ],
      ),
    );
  }
}
