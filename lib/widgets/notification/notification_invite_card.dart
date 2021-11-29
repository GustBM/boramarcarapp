import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/controllers/notifications_controller.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              notification.message,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Icon(Icons.arrow_forward),
          // IconButton(
          //     onPressed: () {
          //       try {
          //         Provider.of<AppNotificationController>(context, listen: false)
          //             .confirmInvite(
          //                 context, notification, false, _userInfo!.uid);
          //       } catch (e) {
          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text(e.toString()),
          //         ));
          //       }
          //     },
          //     icon: Container(
          //       height: double.infinity,
          //       child: Icon(Icons.details),
          //       color: Colors.red,
          //     )),
          Flexible(
              child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 2, primary: Colors.green),
                onPressed: () {},
                child: Text(
                  ' Aceitar ',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(elevation: 2, primary: Colors.red),
                onPressed: () {},
                child: Text(
                  'Recusar',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          )),
          // IconButton(
          //     onPressed: () {
          //       Provider.of<AppNotificationController>(context, listen: false)
          //           .confirmInvite(context, notification, true, _userInfo!.uid);
          //     },
          //     icon: Container(
          //       child: Icon(Icons.check),
          //       color: Colors.green,
          //     )),
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
