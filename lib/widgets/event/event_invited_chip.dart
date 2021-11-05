import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/user.dart';
import 'package:boramarcarapp/providers/users.dart';
import 'package:boramarcarapp/models/event.dart';
import 'package:boramarcarapp/providers/events.dart';

import '../../utils.dart';

class InvitedChipListWithButton extends StatelessWidget {
  final List<String> invitedList;
  final Function setState;
  final bool adminPermission;
  final String eventId;

  InvitedChipListWithButton(
      this.invitedList, this.setState, this.adminPermission, this.eventId);

  final List<String> invitedName = [];

  Widget _buildChip(BuildContext context, AppUser user) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundImage: Image.asset(
          'assets/images/standard_user_photo.png',
        ).image,
      ),
      label: Text(
        user.firstName,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF5f65d3),
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
      deleteIcon: adminPermission ? Icon(Icons.cancel) : Text(''),
      onDeleted: () {
        showConfirmDialog(context, '',
            'Tem certeza que deseja desconvidar ' + user.firstName + '?', () {
          // Provider.of<Events>(context).uninviteUser(eventId, userId)
        });
      },
    );
  }

  List<Widget> listChips(BuildContext context, List<AppUser?> invitedList) {
    List<Widget> chips = [];
    invitedList.forEach((element) {
      chips.add(_buildChip(context, element!));
    });

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppUser?>>(
      future: Provider.of<Users>(context, listen: false)
          .getInvitedUserList(invitedList),
      builder: (BuildContext context, AsyncSnapshot<List<AppUser?>> snapshot) {
        if (snapshot.hasError) {
          return Text("Houve um Erro ao buscar os convidados.");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: listChips(context, snapshot.data!),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
