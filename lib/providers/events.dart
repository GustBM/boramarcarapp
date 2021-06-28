import 'package:boramarcarapp/providers/schedules.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:boramarcarapp/screens/event/event_detail_screen.dart';
import 'package:boramarcarapp/models/event.dart';
import 'package:boramarcarapp/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Events extends ChangeNotifier {
  late final String? authToken;
  // List<Event>? _previousEvents = [];
  CollectionReference events = FirebaseFirestore.instance.collection('event');

  // Events(this.authToken, this._previousEvents);

  List<Event> _eventList = [];

  List<Event> get eventsList {
    return [..._eventList];
  }

  Future<Event>? setDatatoEvent(DocumentSnapshot<Object?> value) async {
    return new Event(
        eventId: value['eventId'],
        name: value['name'],
        manager: value['manager'],
        managerId: value['managerId'],
        date: value['date'],
        dateIni: value['dateIni'],
        dateEnd: value['dateEnd'],
        location: value['location'],
        description: value['description']);
  }

  Future<DocumentSnapshot<Object?>>? findById(String eventId) async {
    return events.doc(eventId).get();
  }

  Future<void> update() async {
    notifyListeners();
  }

  Future<void> addEvent(
      String name,
      String manager,
      String managerId,
      DateTime date,
      DateTime dateIni,
      DateTime dateEnd,
      String location,
      String description,
      BuildContext context,
      List<String> invited,
      String? imageUrl) async {
    List<String> usersId = [];
    List<DateTime> bestDates = [];

    Future.forEach(invited, (element) async {
      var snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: element)
          .get();
      var user = snapshot.docs[0].id;
      print(user);
      usersId.add(user);
    }).then((value) async {
      var dateRange = new DateTimeRange(start: dateIni, end: dateEnd);
      bestDates = await Provider.of<Schedules>(context, listen: false)
          .getIdealDate(dateRange, usersId);
    }).then((dates) {
      return events
          .add({
            'name': name,
            'manager': manager,
            'managerId': managerId,
            'date': bestDates[0],
            'dateIni': dateIni,
            'dateEnd': dateEnd,
            'location': location,
            'imageUrl': imageUrl,
            'description': description,
            'invited': usersId,
          })
          .then((value) => goToEvent(context, value.id, managerId, invited))
          .catchError(
              (e) => throw HttpException("Houve um Erro!" + e.code.toString()));
    });
  }

  Future<void> updateEventUserList(String userId, String id) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    var data = snapshot.data();
    List<String> invitedList = [];

    if (data!['invited'] != null)
      invitedList = new List<String>.from(data['invited']);

    invitedList.add(id);

    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .update({'invited': invitedList});
  }

  void goToEvent(
      BuildContext context, String id, String userId, List<String> invited) {
    updateEventUserList(userId, id);
    Navigator.of(context).pushNamed(
      EventDetailScreen.routeName,
      arguments: id,
    );
  }

  Future<void> getAndFetchEvents(String uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('event')
        .where('invited', arrayContainsAny: [uid]).get();
    var dataAll = snapshot.docs.toList();
    final List<Event> loadedEvents = [];

    dataAll.forEach((ev) async {
      var eventId = ev.id;
      var event = ev.data();
      Event newEvent = new Event(
        eventId: eventId,
        name: event['name'],
        manager: event['manager'],
        managerId: event['managerId'],
        date: event['date'].toDate(),
        dateIni: event['dateIni'].toDate(),
        dateEnd: event['dateEnd'].toDate(),
        location: 'teste',
        description: event['description'],
      );
      loadedEvents.add(newEvent);
    });

    _eventList = loadedEvents;
    notifyListeners();
  }
}
