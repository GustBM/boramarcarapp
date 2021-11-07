import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/providers/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationInviteCard extends StatelessWidget {
  final AppNotification notification;

  NotificationInviteCard(this.notification);

  @override
  Widget build(BuildContext context) {
    final User? _userInfo = FirebaseAuth.instance.currentUser;

    return ListTile(
      leading: CircleAvatar(
        foregroundColor: Theme.of(context).primaryColor,
        // backgroundColor: Colors.grey,
        child: Icon(Icons.group_add),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Text(
              // notification.message,
              'O usuário está te convidando para o evento Evento convite',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Icon(Icons.arrow_forward),
          IconButton(
              onPressed: () {
                Provider.of<AppNotifications>(context)
                    .removeNotification(_userInfo!.uid, notification);
              },
              icon: Container(
                height: double.infinity,
                child: Icon(Icons.details),
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {},
              icon: Container(
                child: Icon(Icons.check),
                color: Colors.green,
              )),
        ],
      ),
      subtitle: Container(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(DateFormat('HH:mm - dd/MM/yyyy').format(notification.date)),
      ),
      onTap: () {
        // Navigator.of(context).pushNamed(
        //   GroupDetailsScreen.routeName,
        //   arguments: groupsList[i].groupId,
        // );
      },
    );
  }
}
