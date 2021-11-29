import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/controllers/users_controller.dart';
import 'package:boramarcarapp/models/user.dart';

class EventInviteModal extends StatefulWidget {
  final List<String> invitedList;
  EventInviteModal(this.invitedList);
  @override
  _EventInviteModalState createState() => _EventInviteModalState();
}

class _EventInviteModalState extends State<EventInviteModal> {
  late List<AppUser> _users = [];

  void addAll(List<AppUser> userList) {
    userList.forEach((element) {
      if (!widget.invitedList.contains(element))
        widget.invitedList.add(element.firstName);
    });
  }

  String _printUserEmails(List<AppUser> users) {
    StringBuffer emails = StringBuffer();
    users.forEach((user) {
      emails.writeln(user.email);
    });

    return emails.toString();
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
                    _users = await Provider.of<UserController>(context,
                            listen: false)
                        .getUsersList(pattern);
                    return _users;
                  },
                  itemBuilder: (context, AppUser appUser) {
                    return _users.length > 1
                        ? appUser.email == _users[0].email
                            ? Expanded(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.group_add),
                                  ),
                                  title: Text('Adicionar os usuários;'),
                                  subtitle: Text(_printUserEmails(_users)),
                                ),
                              )
                            : SizedBox()
                        : Expanded(
                            child: ListTile(
                              leading: CircleAvatar(
                                foregroundColor: Theme.of(context).primaryColor,
                                backgroundColor: Colors.grey,
                                backgroundImage: appUser.imageUrl != null
                                    ? Image.network(appUser.imageUrl!).image
                                    : null,
                                child: Text('${appUser.firstName[0]}'),
                              ),
                              title: Text(appUser.firstName),
                              subtitle: Text(appUser.email),
                            ),
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
                    if (_users.length > 1) {
                      setState(() {
                        _users.forEach((element) {
                          _invitedList.add(element.email);
                        });
                        Navigator.of(context).pop();
                      });
                    } else
                      setState(() {
                        _invitedList.add(suggestion.email);
                        Navigator.of(context).pop();
                      });
                  },
                ),
                actions: <Widget>[
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
        // _invitedList == []
        //     ? InvitedAppUserChipListGroup(_invitedList, true)
        //     : SizedBox(),
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
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: listChips(_invitedList),
    );
  }
}
