import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/controllers/notifications_controller.dart';

class NotificationInviteCard extends StatefulWidget {
  final AppNotification notification;

  NotificationInviteCard(this.notification);

  @override
  State<NotificationInviteCard> createState() => _NotificationInviteCardState();
}

class _NotificationInviteCardState extends State<NotificationInviteCard> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final User? _userInfo = FirebaseAuth.instance.currentUser;
    return ListTile(
      leading: CircleAvatar(
        foregroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.group_add),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              widget.notification.message,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Column(
              children: !_isLoading
                  ? [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2, primary: Colors.green),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            Provider.of<AppNotificationController>(context,
                                    listen: false)
                                .confirmInvite(context, widget.notification,
                                    true, _userInfo!.uid);
                          });
                          _isLoading = false;
                        },
                        child: Text(
                          ' Aceitar ',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2, primary: Colors.red),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            Provider.of<AppNotificationController>(context,
                                    listen: false)
                                .confirmInvite(context, widget.notification,
                                    false, _userInfo!.uid);
                          });
                          _isLoading = false;
                        },
                        child: Text(
                          'Recusar',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ]
                  : [CircularProgressIndicator()],
            ),
          ),
        ],
      ),
      subtitle: Container(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
            DateFormat('HH:mm - dd/MM/yyyy').format(widget.notification.date)),
      ),
    );
  }
}
