import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/controllers/groups_controller.dart';
import 'package:boramarcarapp/models/group.dart';
import 'package:boramarcarapp/widgets/group/group_invite_chip.dart';

import '../../utils.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/group-details';

  @override
  Widget build(BuildContext context) {
    final User? _userInfo = FirebaseAuth.instance.currentUser;
    final groupId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<GroupController>(context, listen: false)
            .getGroup(groupId),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Group>> snapshot) {
          if (snapshot.hasError) {
            return SnapshotErroMsg(
                'Houve um erro ao buscar o Evento.\nTente novamente mais tarde.');
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return SnapshotErroMsg(
                "Evento não encontrado ou deletado. Verifique o link.");
          }
          Group? thisGroup;
          if (snapshot.connectionState == ConnectionState.done) {
            if (!(snapshot.hasData && !snapshot.data!.exists)) {
              thisGroup = snapshot.data!.data();
            }
            final managerPermission = thisGroup!.groupAdmin == _userInfo!.uid;
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Grupo'),
                  ],
                ),
                actions: <Widget>[
                  managerPermission
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Edit group info
                          },
                        )
                      : Text(''),
                ],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pushNamed('/'),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: double.infinity,
                      child:
                          thisGroup.imageUrl == '' || thisGroup.imageUrl == null
                              ? Image.asset(
                                  'assets/images/baloes.jpg',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  thisGroup.imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      thisGroup.name,
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Text(
                        thisGroup.description!,
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            Column(
                              children: [
                                Text(" ",
                                    textScaleFactor: 1.1,
                                    textAlign: TextAlign.center),
                                Divider(thickness: 0)
                              ],
                            ),
                            Column(
                              children: [
                                Text(" ",
                                    textScaleFactor: 1.1,
                                    textAlign: TextAlign.left),
                                Divider(thickness: 0)
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Text("Membros", textScaleFactor: 1.5),
                    InvitedAppUserChipListGroup(thisGroup.groupMembers, false),
                    SizedBox(height: 30),
                    managerPermission
                        ? OutlinedButton(
                            child: Text("Deletar Grupo"),
                            onPressed: () {
                              showConfirmDialog(
                                  context,
                                  'Deletar Grupo ' + thisGroup!.name,
                                  'Tem certeza que deseja deletar o grupo?',
                                  () {
                                Provider.of<GroupController>(context,
                                        listen: false)
                                    .deleteGroup(groupId);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                            },
                          )
                        : OutlinedButton(
                            child: Text("Sair do Grupo"),
                            onPressed: () {
                              showConfirmDialog(
                                  context,
                                  'Sair de ' + thisGroup!.name,
                                  'Tem certeza que deseja sair do grupo?', () {
                                Provider.of<GroupController>(context,
                                        listen: false)
                                    .leaveGroup(groupId, _userInfo.email!);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                            }),
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
