import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:boramarcarapp/view/event/event_new_screen.dart';
import 'package:boramarcarapp/controllers/events_controller.dart';
import 'package:boramarcarapp/models/event.dart';
import 'package:boramarcarapp/utils.dart';
import 'package:boramarcarapp/widgets/event/event_invited_chip.dart';

class EventDetailScreen extends StatefulWidget {
  static const routeName = '/event-detail';

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  // void setInvitedList(Future<DocumentSnapshot<Object?>>? loadedEvent) {}

  @override
  Widget build(BuildContext context) {
    final eventId = ModalRoute.of(context)!.settings.arguments as String;
    final User? _userInfo = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<EventController>(context, listen: false)
            .getEvent(eventId),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Event>?> snapshot) {
          if (snapshot.hasError) {
            return SnapshotErroMsg(
                'Houve um erro ao buscar o Evento.\nTente novamente mais tarde.');
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return SnapshotErroMsg(
                "Evento não encontrado ou deletado. Verifique o link.");
          }
          Event? thisEvent;
          if (snapshot.connectionState == ConnectionState.done) {
            if (!(snapshot.hasData && !snapshot.data!.exists)) {
              thisEvent = snapshot.data!.data();
            }
            final managerPermission = thisEvent!.managerId == _userInfo!.uid;
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Evento'),
                  ],
                ),
                actions: <Widget>[
                  managerPermission
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                EventFormScreen.routeName,
                                arguments: eventId);
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
                          thisEvent.imageUrl == '' || thisEvent.imageUrl == null
                              ? Hero(
                                  tag: thisEvent.eventId,
                                  child: Image.asset(
                                    'assets/images/baloes.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Hero(
                                  tag: thisEvent.eventId,
                                  child: Image.network(
                                    thisEvent.imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      thisEvent.name,
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
                        thisEvent.description,
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
                          TableRow(children: [
                            Text("Endereço",
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.left),
                            Text(thisEvent.location,
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.left),
                          ]),
                          TableRow(children: [
                            Text("Data",
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.left),
                            Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(thisEvent.date)
                                    .toString(),
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.left),
                          ]),
                          TableRow(children: [
                            Text("Hora",
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.left),
                            Text(
                                DateFormat('hh:mm')
                                    .format(thisEvent.date)
                                    .toString(),
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.left),
                          ]),
                          TableRow(children: [
                            Text("Responsável",
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.left),
                            Text(thisEvent.manager,
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.left),
                          ]),
                        ],
                      ),
                    ),
                    Text("Convidados", textScaleFactor: 1.5),
                    // InvitedChipListWithButton(thisEvent.invited, () {},
                    //     managerPermission, thisEvent.eventId),
                    InvitedAppUserChipListEvent(thisEvent.invited, false),
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
