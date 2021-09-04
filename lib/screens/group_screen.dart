import 'package:boramarcarapp/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  GroupsScreen({Key? key}) : super(key: key);
  static const routeName = '/groups';
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Teste'),
      ),
    );
  }
}
