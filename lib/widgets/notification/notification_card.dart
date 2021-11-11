import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/widgets/notification/notification_invite_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;

  NotificationCard(this.notification);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(height: 10.0),
        notification.notificationType == NotificationType.notify
            ? ListTile(
                leading: CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  // backgroundColor: Colors.grey,
                  child: Icon(Icons.notifications),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      notification.message,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Icon(Icons.arrow_forward),
                  ],
                ),
                subtitle: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(DateFormat('HH:mm - dd/MM/yyyy')
                      .format(notification.date)),
                ),
              )
            : NotificationInviteCard(notification),
        Divider(height: 10.0),
      ],
    );
  }
}
