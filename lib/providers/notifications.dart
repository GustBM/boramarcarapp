import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:boramarcarapp/models/notification.dart';

class AppNotifications extends ChangeNotifier {
  CollectionReference _users = FirebaseFirestore.instance.collection('user');
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<AppNotification>> get getUserNotifications async {
    List<AppNotification> notifications = [];
    await _users.doc(_uid).get().then((docSnapshot) {
      (docSnapshot['notifications'] as List<dynamic>).forEach((notification) {
        notifications.add(new AppNotification(
            date: (notification['date'] as Timestamp).toDate(),
            message: notification['message'],
            redirectUrl: notification['message'],
            hasResponded: notification['hasResponded'],
            hasSeen: notification['hasSeen']));
      });
    });
    return notifications;
  }

  Future<int> get getUnreadNotificationsNumber async {
    int unreadNum = 0;
    await _users.doc(_uid).get().then((docSnapshot) {
      (docSnapshot['notifications'] as List<dynamic>).forEach((notification) {
        if (!notification['hasSeen']) {
          unreadNum++;
        }
      });
    });
    return unreadNum;
  }

  Future<void> addUserNotifications(
      String userId, AppNotification notification) async {
    await _users.doc(_uid).update(
      {
        'notifications': FieldValue.arrayUnion([notification.toJson()])
      },
    );
  }
}
