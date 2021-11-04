import 'package:boramarcarapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Users extends ChangeNotifier {
  CollectionReference _schedules =
      FirebaseFirestore.instance.collection('user');

  Future<DocumentSnapshot<AppUser>> getAppUserInfo(String uid) async {
    return await _schedules
        .doc(uid)
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
  }

  Future<QuerySnapshot<AppUser>> getAppUserByEmail(String email) async {
    return _schedules
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
      qShot = await _schedules.where('email', whereIn: emailList).get();
    } else
      qShot = await _schedules.where('email', isEqualTo: email).get();

    return qShot.docs
        .map((user) => AppUser(
              firstName: user['firstName'],
              lastName: user['lastName'],
              email: user['email'],
            ))
        .toList();
  }

  Future<List<AppUser?>> getInvitedUserList(List<String> userIds) async {
    List<AppUser?> invitedList = [];
    userIds.forEach((id) => {
          _schedules
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
    _schedules
        .doc(userId)
        .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .set(appUser);
  }
}
