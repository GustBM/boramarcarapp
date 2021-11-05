import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/providers/notifications.dart';
import 'package:boramarcarapp/widgets/notification/notification_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? _userInfo = FirebaseAuth.instance.currentUser;
    var notification = new AppNotification(
        message: 'message', date: DateTime.now(), redirectUrl: '');
    // Provider.of<AppNotifications>(context)
    //     .addUserNotifications(_userInfo!.uid, notification);
    return Scaffold(
      appBar: AppBar(),
      body: NotificationCard(notification),
    );
  }
}
