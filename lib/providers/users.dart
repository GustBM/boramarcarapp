import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Users extends ChangeNotifier {
  CollectionReference _users = FirebaseFirestore.instance.collection('user');
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<DocumentSnapshot<AppUser>> getAppUserInfo(String uid) async {
    return await _users
        .doc(uid)
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
  }

  Future<QuerySnapshot<AppUser>> getAppUserByEmail(String email) async {
    return _users
        .where('email', isEqualTo: email)
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
  }

  Future<List<AppUser>> getUsersList(String email) async {
    List<String> emailList;
    QuerySnapshot qShot;
    if (email.contains(';')) {
      emailList = email.split(';');
      print(emailList);
      qShot = await _users.where('email', whereIn: emailList).get();
    } else
      qShot = await _users.where('email', isEqualTo: email).get();

    return qShot.docs
        .map((user) => AppUser(
              uid: user['uid'],
              firstName: user['firstName'],
              lastName: user['lastName'],
              email: user['email'],
            ))
        .toList();
  }

  Future<List<AppUser?>> getInvitedUserList(List<String> userIds) async {
    List<AppUser?> invitedList = [];
    userIds.forEach((id) => {
          _users
              .doc(id)
              .withConverter<AppUser>(
                  fromFirestore: (snapshot, _) =>
                      AppUser.fromJson(snapshot.data()!),
                  toFirestore: (schedule, _) => schedule.toJson())
              .get()
              .then((value) {
            invitedList.add(value.data());
          })
        });
    return invitedList;
  }

  Future<void> addAndUpdateAppUser(String userId, AppUser appUser) async {
    _users
        .doc(userId)
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .set(appUser);
  }

  // Future<List<AppNotification>> get getUserNotifications async {
  //   await _users
  //       .doc(_uid)
  //       .withConverter<AppUser>(
  //           fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
  //           toFirestore: (schedule, _) => schedule.toJson())
  //       .get()
  //       .then((docSnapshot) {
  //     return docSnapshot.data()!.notifications;
  //   }).onError((error, stackTrace) => throw HttpException(
  //           'Erro ao buscar Notificações. Verifique a conexão e tente novamente.'));
  //   return [];
  // }

  // Future<void> addUserNotifications(
  //     String userId, AppNotification notification) async {
  //   await _users.doc("VUjOHQ6XIKYXokTe7mhElJYFaEB2").update(
  //     {
  //       'notifications': FieldValue.arrayUnion([notification])
  //     },
  //   );
  // }
}
