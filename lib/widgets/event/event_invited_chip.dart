import 'package:flutter/material.dart';

class InvitedChipList extends StatelessWidget {
  final List<String> invitedList;
  final Function setState;

  InvitedChipList(this.invitedList, this.setState);

  Widget _buildChip(String label) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundImage: Image.asset(
          'assets/images/standard_user_photo.png',
        ).image,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF5f65d3),
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
      deleteIcon: Icon(Icons.cancel),
      onDeleted: () {
        setState(label);
      },
    );
  }

  List<Widget> listChips() {
    List<Widget> chips = [];

    invitedList.forEach((element) {
      var chip = _buildChip(element);
      chips.add(chip);
    });

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: listChips(),
    );
  }
}
