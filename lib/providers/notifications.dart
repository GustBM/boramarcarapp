import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/models/user.dart';

class AppNotifications extends ChangeNotifier {
  CollectionReference _users = FirebaseFirestore.instance.collection('user');
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<AppNotification>> get getUserNotifications async {
    await _users
        .doc(_uid)
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get()
        .then((docSnapshot) {
      return docSnapshot.data()!.notifications;
    }).onError((error, stackTrace) => throw HttpException(
            'Erro ao buscar Notificações. Verifique a conexão e tente novamente.'));
    return [];
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
