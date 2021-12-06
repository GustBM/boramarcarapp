import 'package:boramarcarapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/controllers/events_controller.dart';
import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/view/event/event_detail_screen.dart';

class AppNotificationController extends ChangeNotifier {
  CollectionReference _users = FirebaseFirestore.instance.collection('user');
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<AppNotification>> get getUserNotifications async {
    List<AppNotification> notifications = [];
    await _users.doc(_uid).get().then((docSnapshot) {
      (docSnapshot['notifications'] as List<dynamic>).forEach((notification) {
        notifications.add(new AppNotification(
            date: (notification['date'] as Timestamp).toDate(),
            message: notification['message'],
            redirectUrl: notification['redirectUrl'],
            hasResponded: notification['hasResponded'],
            hasSeen: false,
            notificationType: NotificationType.values
                .elementAt(notification['notificationType'])));
      });
    });
    return notifications;
  }

  Future<int> get getUnreadNotificationsNumber async {
    int unreadNum = 0;
    try {
      await _users.doc(_uid).get().then((docSnapshot) {
        (docSnapshot['notifications'] as List<dynamic>).forEach((notification) {
          if (!notification['hasSeen']) {
            unreadNum++;
          }
        });
      });
    } catch (e) {
      return 0;
    }
    return unreadNum;
  }

  static Future<void> addUserNotifications(
      String userId, AppNotification notification, String title) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(userId).update(
        {
          'notifications': FieldValue.arrayUnion([notification.toJson()])
        },
      );

      var snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .withConverter<AppUser>(
              fromFirestore: (snapshot, _) =>
                  AppUser.fromJson(snapshot.data()!),
              toFirestore: (schedule, _) => schedule.toJson())
          .get();
      AppUser appUser = snapshot.data()!;
      await OneSignal.shared.postNotification(
        OSCreateNotification(
            playerIds: [appUser.playerId!],
            content: notification.message,
            heading: title,
            buttons: [
              OSActionButton(text: "Ver Notificações", id: "id1"),
            ]),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future removeNotification(AppNotification notification) async {
    await _users.doc(_uid).update(
      {
        'notifications': FieldValue.arrayRemove([notification.toJson()])
      },
    );
  }

  Future<void> confirmInvite(BuildContext context, AppNotification notification,
      bool response, String invitedUserId) async {
    try {
      if (response) {
        await Provider.of<EventController>(context, listen: false)
            .addInvited(notification.redirectUrl, invitedUserId)
            .then((_) => Navigator.of(context).pushNamed(
                  EventDetailScreen.routeName,
                  arguments: notification.redirectUrl,
                ));
      } else {
        removeNotification(notification);
        Navigator.of(context).pop();
      }
    } catch (e) {
      throw HttpException(
          'Houve um erro ao confirmar o convite. Tente novamente mais tarde.');
    }
  }

  Future notifyUser(String uid, String title, String message) async {
    var snapshot = await _users
        .doc(uid)
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
    AppUser appUser = snapshot.data()!;

    try {
      await OneSignal.shared.postNotification(
        OSCreateNotification(
            playerIds: [appUser.playerId!],
            content: message,
            heading: title,
            buttons: [
              OSActionButton(text: "Abrir", id: "id1"),
            ]),
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
