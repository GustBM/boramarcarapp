import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/user.dart';
import 'package:boramarcarapp/controllers/users_controller.dart';
import 'package:boramarcarapp/widgets/empty_message_widget.dart';

import '../../utils.dart';

class InvitedAppUserChipListGroup extends StatefulWidget {
  final List<String> invitedEmails;
  final bool canEdit;

  InvitedAppUserChipListGroup(this.invitedEmails, this.canEdit);

  @override
  _InvitedAppUserChipListGroupState createState() =>
      _InvitedAppUserChipListGroupState();
}

class _InvitedAppUserChipListGroupState
    extends State<InvitedAppUserChipListGroup> {
  Widget _buildChip(AppUser user) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundImage: Image.asset(
          'assets/images/standard_user_photo.png',
        ).image,
        foregroundImage:
            user.imageUrl != null ? Image.network(user.imageUrl!).image : null,
      ),
      label: Container(
          height: 40,
          child: Column(
            children: [
              Text(
                user.firstName,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                user.email,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            ],
          )),
      backgroundColor: Color(0xFF5f65d3),
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      deleteIcon: widget.canEdit ? Icon(Icons.cancel) : Icon(null),
      onDeleted: () {
        if (widget.canEdit) {
          print('object');
        }
      },
    );
  }

  List<Widget> listChips(List<AppUser> invitedList) {
    List<Widget> chips = [];
    invitedList.forEach((element) {
      chips.add(_buildChip(element));
    });

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<AppUser>>(
        future: Provider.of<UserController>(context)
            .getAppUserListFromEmails(widget.invitedEmails),
        builder: (context, AsyncSnapshot<QuerySnapshot<AppUser>> snapshot) {
          if (snapshot.hasError) {
            return SnapshotErroMsg(
                'Houve um erro ao buscar os membros deste Grupo.\nTente novamente mais tarde.');
          }

          if (snapshot.hasData && snapshot.data!.size == 0) {
            return EmptyMessage(
              icon: Icons.group,
              messageText:
                  "Nenhum membro encontrado.\nGostaria de adicionar ao seu grupo?",
              buttonFunction: () => {},
              buttonText: 'Convidar para Grupo',
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List<AppUser> usersList = snapshot.data!.docs
                .map((user) => AppUser(
                    uid: user.data().uid,
                    firstName: user.data().firstName,
                    email: user.data().email,
                    imageUrl: user.data().imageUrl))
                .toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: listChips(usersList),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
