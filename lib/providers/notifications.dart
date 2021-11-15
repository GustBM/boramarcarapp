import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/screens/event/event_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/screens/home_screen.dart';
import 'package:provider/provider.dart';

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
            redirectUrl: notification['redirectUrl'],
            hasResponded: notification['hasResponded'],
            hasSeen: true,
            notificationType: NotificationType.values
                .elementAt(notification['notificationType'])));
        _updateAsReadNotification(notifications);
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

  Future _removeNotification(AppNotification notification) async {
    await _users.doc(_uid).update(
      {
        'notifications': FieldValue.arrayRemove([notification.toJson()])
      },
    );
  }

  Future _updateAsReadNotification(List<AppNotification> notification) async {
    late var list;
    notification.forEach((element) {
      list = FieldValue.arrayUnion([element.toJson()]);
    });
    await _users.doc(_uid).update({'notifications': list});
  }

  Future<void> confirmInvite(BuildContext context, AppNotification notification,
      bool response, String invitedUserId) async {
    try {
      if (response) {
        await Provider.of<Events>(context, listen: false)
            .addInvited(notification.redirectUrl, invitedUserId)
            .then((value) => Navigator.of(context).pushNamed(
                  EventDetailScreen.routeName,
                  arguments: notification.redirectUrl,
                ));
      } else {
        _removeNotification(notification);
      }
    } catch (e) {
      throw HttpException(
          'Houve um erro ao confirmar o convite. Tente novamente mais tarde.');
    }
  }
}

class Controller extends GetxController {
  void sendNotification() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'test_channel',
          title: 'Title of the notification.',
          body: 'Hello! This is the body of the notification.'),
    );

    AwesomeNotifications().actionStream.listen((event) {
      Get.to(HomeScreen());
    });
  }
}

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<Controller>(Controller());
  }
}
