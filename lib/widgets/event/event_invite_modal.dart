import 'package:flutter/material.dart';

class EventInviteModal extends StatefulWidget {
  final List<String> invitedList;
  final Function addInvited;
  EventInviteModal(this.invitedList, this.addInvited);

  @override
  _EventInviteModalState createState() => _EventInviteModalState();
}

class _EventInviteModalState extends State<EventInviteModal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), child: null),
        ),
      ],
    );
  }
}
