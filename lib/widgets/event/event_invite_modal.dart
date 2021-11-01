import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/user.dart';
import 'package:boramarcarapp/providers/users.dart';

class EventInviteModal extends StatefulWidget {
  final List<String> invitedList;
  EventInviteModal(this.invitedList);
  @override
  _EventInviteModalState createState() => _EventInviteModalState();
}

class _EventInviteModalState extends State<EventInviteModal> {
  List<AppUser> _users = [];

  void addAll(List<AppUser> userList) {
    userList.forEach((element) {
      if (!widget.invitedList.contains(element))
        widget.invitedList.add(element.firstName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _invitedList = widget.invitedList;

    return Column(
      children: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: Text(
                  'Adicionar Convidados',
                  style: TextStyle(fontSize: 20),
                ),
                content: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  suggestionsCallback: (pattern) async {
                    return await Provider.of<Users>(context, listen: false)
                        .getUsersList(pattern);
                  },
                  itemBuilder: (context, AppUser appUser) {
                    if (appUser.firstName == 'gambiarra') {
                      return ListTile(
                        leading: Icon(Icons.group_work),
                        title: Text('Clique aqui para adicionar os convidados'),
                      );
                    } else
                      return ListTile(
                        leading: CircleAvatar(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey,
                          // backgroundImage: appUser.
                          //     Image.asset('assets/images/standard_user_photo.png')
                          //         .image,
                          child: Text('${appUser.firstName[0]}'),
                        ),
                        title: Text(appUser.firstName),
                        subtitle: Text(appUser.email),
                      );
                  },
                  noItemsFoundBuilder: (context) {
                    return ListTile(
                      leading: Icon(Icons.search),
                      title: Text('Escreva o e-mail do convidado.'),
                      subtitle: Text(
                          'Caso queira convidar múltiplos, separe o e-mail com \';\' e clique em convidar todos.'),
                    );
                  },
                  onSuggestionSelected: (AppUser suggestion) {
                    setState(() {
                      _invitedList.add(suggestion.email);
                      Navigator.of(context).pop();
                    });
                  },
                ),
                actions: <Widget>[
                  // TextButton(
                  //   child:
                  //       Text('Convidar Todos', style: TextStyle(fontSize: 16)),
                  //   onPressed: () {
                  //     addAll(_users);
                  //     setState(() {});
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  TextButton(
                    child: Text('Fechar', style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: Text(
            '+ Adicionar Convidados',
            style:
                TextStyle(decoration: TextDecoration.underline, fontSize: 22),
          ),
        ),
        InvitedChipList(_invitedList),
      ],
    );
  }
}

class InvitedChipList extends StatefulWidget {
  final List<String> invitedList;
  InvitedChipList(this.invitedList);

  @override
  _InvitedChipListState createState() => _InvitedChipListState();
}

class _InvitedChipListState extends State<InvitedChipList> {
  void removeChip(String label) {
    setState(() {
      widget.invitedList.removeWhere((element) => element == label);
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
      // padding: EdgeInsets.all(8.0),
      deleteIcon: Icon(Icons.cancel),
      onDeleted: () {
        removeChip(label);
      },
    );
  }

  List<Widget> listChips(List<String> invitedList) {
    List<Widget> chips = [];
    invitedList.forEach((element) {
      chips.add(_buildChip(element));
    });

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _invitedList = widget.invitedList;

    // return GridView.count(
    //   padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
    //   crossAxisCount: 2,
    //   children: _invitedList.map((e) {
    //     return _buildChip(e);
    //   }).toList(),
    //   shrinkWrap: true,
    // );
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: listChips(_invitedList),
    );
  }
}
