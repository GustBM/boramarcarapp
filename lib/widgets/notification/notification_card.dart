import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/controllers/notifications_controller.dart';
import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/view/event/event_detail_screen.dart';
import 'package:boramarcarapp/widgets/notification/notification_invite_card.dart';

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
                    Flexible(
                      child: Text(
                        notification.message,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Icon(Icons.arrow_forward),
                  ],
                ),
                subtitle: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(DateFormat('HH:mm - dd/MM/yyyy')
                      .format(notification.date)),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    EventDetailScreen.routeName,
                    arguments: notification.redirectUrl,
                  );
                  Provider.of<AppNotificationController>(context, listen: false)
                      .removeNotification(notification);
                },
              )
            : NotificationInviteCard(notification),
        Divider(height: 10.0),
      ],
    );
  }
}
