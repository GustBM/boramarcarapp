import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:boramarcarapp/models/user.dart';

class Users extends ChangeNotifier {
  CollectionReference _users = FirebaseFirestore.instance.collection('user');

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

  Future<QuerySnapshot<AppUser>> getAppUserListFromEmails(
      List<String> invitedEmails) {
    return _users
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .where('email', whereIn: invitedEmails)
        .get();
  }

  Future<QuerySnapshot<AppUser>> getAppUserListFromUserId(
      List<String> invitedIds) {
    return _users
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .where('uid', whereIn: invitedIds)
        .get();
  }
}
