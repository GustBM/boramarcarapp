import 'package:boramarcarapp/models/user.dart';
import 'package:boramarcarapp/providers/auth.dart';
import 'package:boramarcarapp/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchedueleScreen extends StatelessWidget {
  static const routeName = '/schedule';

  @override
  Widget build(BuildContext context) {
    // final AppUser _userData = Provider.of<Auth>(context).getUserInfo;
    final User? _userInfo = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Meu Horário')),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Text((_userInfo != null ? _userInfo.email : '')!),
        ],
      ),
    );
  }
}
