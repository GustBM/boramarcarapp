import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:boramarcarapp/screens/event/event_detail_screen.dart';
import 'package:boramarcarapp/models/event.dart';

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
        location: value['location'],
        description: value['description']);
  }

  /*Future<Event?>? findById(String eventId) async {
    Future<Event?>? resp;

    events.doc(eventId).get().then((value) {
      resp = setDatatoEvent(value);
    }).catchError((error) {
      print('Failed to add event: $error');
      return null;
    }).whenComplete(() {
      return resp;
    });
  }*/

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
      String location,
      String description,
      BuildContext context,
      String? imageUrl) {
    return events
        .add({
          'name': name,
          'manager': manager,
          'managerId': manager,
          'date': date,
          'location': location,
          'imageUrl': imageUrl,
          'description': description,
        })
        .then((value) => goToEvent(context, value.id))
        .catchError((error) => print('Failed to add event: $error'));
  }

  void goToEvent(BuildContext context, String id) {
    Navigator.of(context).pushNamed(
      EventDetailScreen.routeName,
      arguments: id,
    );
  }

  Future<void> getAndFetchEvents() async {
    var snapshot = await FirebaseFirestore.instance.collection('event').get();
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
        location: 'teste',
        description: event['description'],
      );
      loadedEvents.add(newEvent);
    });

    _eventList = loadedEvents;
    notifyListeners();
  }
}
