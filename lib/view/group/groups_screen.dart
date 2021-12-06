import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/controllers/groups_controller.dart';
import 'package:boramarcarapp/models/group.dart';
import 'package:boramarcarapp/view/group/group_details_screen.dart';
import 'package:boramarcarapp/view/group/group_new_screen.dart';
import 'package:boramarcarapp/widgets/empty_message_widget.dart';

import '../../utils.dart';

class GroupsScreen extends StatefulWidget {
  GroupsScreen({Key? key}) : super(key: key);
  static const routeName = '/groups';
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final User? _userInfo = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Grupos'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(NewGroupScreen.routeName);
            },
          ),
        ],
      ),
      // drawer: AppDrawer(),
      body: FutureBuilder<QuerySnapshot<Group>>(
        future: Provider.of<GroupController>(context, listen: false)
            .getUserGroups(_userInfo!.email!),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Group>> snapshot) {
          if (snapshot.hasError) {
            return SnapshotErroMsg(
                'Houve um erro ao buscar o Evento.\nTente novamente mais tarde.');
          }

          if (snapshot.hasData && snapshot.data!.size == 0) {
            return EmptyMessage(
              icon: Icons.group,
              messageText:
                  "Nenhum grupo encontrado.\nGostaria de criar seu grupo?",
              buttonFunction: () =>
                  Navigator.of(context).pushNamed(NewGroupScreen.routeName),
              buttonText: 'Novo Grupo',
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List<Group> groupsList = snapshot.data!.docs
                .map((group) => Group(
                    groupId: group.data().groupId,
                    name: group.data().name,
                    groupAdmin: group.data().groupAdmin,
                    imageUrl: group.data().imageUrl,
                    description: group.data().description,
                    groupMembers: group.data().groupMembers))
                .toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: groupsList.length,
                itemBuilder: (context, i) => Column(
                  children: <Widget>[
                    Divider(height: 10.0),
                    ListTile(
                      leading: CircleAvatar(
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.grey,
                        foregroundImage: null,
                        child: Text('${groupsList[i].name[0].toUpperCase()}'),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            groupsList[i].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                      subtitle: Container(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: groupsList[i].description == null
                            ? Text('')
                            : Text(
                                groupsList[i].description!,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          GroupDetailsScreen.routeName,
                          arguments: groupsList[i].groupId,
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
