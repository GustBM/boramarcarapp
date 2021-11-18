import 'package:boramarcarapp/view/group/group_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:boramarcarapp/models/group.dart';
import 'package:boramarcarapp/models/http_exception.dart';

class GroupController extends ChangeNotifier {
  CollectionReference _groups = FirebaseFirestore.instance.collection('group');

  void _goToGroup(BuildContext context, String groupId) {
    Navigator.of(context).pushNamed(
      GroupDetailsScreen.routeName,
      arguments: groupId,
    );
  }

  Future<QuerySnapshot<Group>> getUserGroups(String userEmail) async {
    return _groups
        .where('groupMembers', arrayContainsAny: [userEmail])
        .withConverter<Group>(
            fromFirestore: (snapshot, _) => Group.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
  }

  Future<void> addNewGroup(BuildContext context, Group newGroup) async {
    _groups
        .withConverter<Group>(
            fromFirestore: (snapshot, _) => Group.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .doc(newGroup.groupId)
        .set(newGroup)
        .then((group) => _goToGroup(context, newGroup.groupId))
        .catchError((e) => throw HttpException(e.toString()));
  }

  Future<void> updateGroup(String groupId, Group group) async {
    try {
      _groups
          .doc(groupId)
          .withConverter<Group>(
              fromFirestore: (snapshot, _) => Group.fromJson(snapshot.data()!),
              toFirestore: (schedule, _) => schedule.toJson())
          .set(group);
    } catch (e) {
      throw HttpException(
          'Erro ao atualizar dados do grupo. Tente novamente mais tarde.');
    }
  }

  Future<DocumentSnapshot<Group>> getGroup(String groupId) async {
    return _groups
        .withConverter<Group>(
            fromFirestore: (snapshot, _) => Group.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .doc(groupId)
        .get();
  }
}
