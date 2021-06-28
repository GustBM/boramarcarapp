import 'package:boramarcarapp/models/http_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InvitedChipList extends StatelessWidget {
  final List<String> invitedList;
  final Function setState;

  InvitedChipList(this.invitedList, this.setState);

  final List<String> invitedName = [];
  Future<void> getUserById() async {
    invitedList.forEach((element) async {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(element)
            .get();
        var data = snapshot.data();
        invitedName.add(data!['firstName']);
      } catch (e) {
        throw HttpException("Houve um ao buscar os convidados!" + e.toString());
      }
    });
  }

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

    invitedName.forEach((element) {
      var chip = _buildChip(element);
      chips.add(chip);
    });

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getUserById(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("Houve um Erro ao buscar os convidados.");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: listChips(),
          );
        }

        return Text("Buscando Convidados...");
      },
    );
  }
}
