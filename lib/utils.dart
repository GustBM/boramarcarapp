import 'dart:math';

import 'package:flutter/material.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

bool isValidEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

void showConfirmDialog(
    BuildContext context, String title, String text, Function confirmFunction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            child: Text("Ok"),
            onPressed: () {
              confirmFunction();
            },
          ),
          TextButton(
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Text(message),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Ok"))
      ],
    ),
  );
}

class SnapshotEmptyMsg extends StatelessWidget {
  final String msg;
  SnapshotEmptyMsg(this.msg);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }
}

class SnapshotErroMsg extends StatelessWidget {
  final String msg;
  SnapshotErroMsg(this.msg);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            msg,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Text(
              'Voltar',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
