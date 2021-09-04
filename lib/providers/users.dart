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
