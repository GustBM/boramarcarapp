import 'package:flutter/material.dart';

import '../../utils.dart';

class EventInviteModal extends StatefulWidget {
  final TextEditingController? userEmailController;
  final Function addToList;
  EventInviteModal(this.userEmailController, this.addToList);
  @override
  _EventInviteModalState createState() => _EventInviteModalState();
}

class _EventInviteModalState extends State<EventInviteModal> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController? userEmailController =
        widget.userEmailController;
    // final List<String> invitedList = widget.invitedList;
    final Function addToList = widget.addToList;
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: Text(
              'Insira o e-mail do convidado',
              style: TextStyle(fontSize: 20),
            ),
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Insira o e-mail'),
                    controller: userEmailController,
                  ),
                ),
                Text(
                  'Erro',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Fechar', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text(
                    'Adicionar Convidado',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (isValidEmail(userEmailController!.value.text)) {
                      setState(() {
                        addToList(userEmailController.value.text);
                      });
                      Navigator.of(context).pop();
                    }
                  }),
            ],
          ),
        );
      },
      child: Text(
        '+ Adicionar Convidado',
        style: TextStyle(decoration: TextDecoration.underline, fontSize: 22),
      ),
    );
  }
}
