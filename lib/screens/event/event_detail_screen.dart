import 'package:boramarcarapp/models/event.dart';
import 'package:boramarcarapp/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:boramarcarapp/providers/events.dart';

class EventDetailScreen extends StatelessWidget {
  static const routeName = '/event-detail';

  @override
  Widget build(BuildContext context) {
    final eventId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedEvent =
        Provider.of<Events>(context, listen: false).findById(eventId);
    final User? _userInfo = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: loadedEvent,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return SnapshotErroMsg(
                'Houve um erro ao buscar o Evento.\nTente novamente mais tarde.');
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return SnapshotErroMsg(
                "Evento não encontrado ou deletado. Verifique o link.");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            final thisEvent = new Event(
              eventId: eventId,
              name: data['name'],
              manager: data['manager'],
              managerId: data['managerId'],
              date: DateTime.parse(data['date'].toDate().toString()),
              location: data['location'],
              description: data['description'],
            );
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(thisEvent.name),
                  ],
                ),
                actions: <Widget>[
                  thisEvent.managerId == _userInfo!.uid
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigator.of(context).pushNamed(EditProductScreen.routeName);
                          },
                        )
                      : Text(''),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: thisEvent.imageUrl == ''
                          ? Image.asset(
                              'assets/images/baloes.jpg',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              thisEvent.imageUrl,
                              fit: BoxFit.cover,
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
