import 'dart:convert';

import 'package:boramarcarapp/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Events extends ChangeNotifier {
  final String authToken;
  List<Event> _previousEvents = [];
  CollectionReference events = FirebaseFirestore.instance.collection('event');

  Events(this.authToken, this._previousEvents);

  List<Event> _eventList = [];
  /*Event(
      eventId: 'asdf',
      name: 'Mega churras pós pandemia',
      manager: 'User 1',
      managerId: '1234',
      date: DateTime.now(),
      location: 'Av. da Rua',
      description: 'asdfasfasfd',
    ),
    Event(
      eventId: 'zxcv',
      name: 'Reunião importante pacas',
      manager: 'User 1',
      managerId: '1234',
      date: DateTime.now(),
      location: 'Av. da Rua',
      description: 'asdfasfasfd',
    ),
    Event(
      eventId: 'rtyu',
      name: 'Provided to YouTube by RCA Records Label',
      manager: 'User 1',
      managerId: '1234',
      date: DateTime.now(),
      location: 'Av. da Rua',
      description: 'asdfasfasfd',
    ),
  ];*/

  List<Event> get eventsList {
    return [..._eventList];
  }

  Event findById(String eventId) {
    return _eventList.firstWhere((element) => element.eventId == eventId);
  }

  /*Future<void> getAndFetchEvents() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('event').snapshots()
  }*/

  Future<void> addEvent(Event event) {
    return events
        .add({
          'name': event.name,
          'manager': event.manager,
          'managerId': event.manager,
          'date': event.date,
          'location': event.location,
          'imageUrl': event.imageUrl,
          'description': event.description,
        })
        .then((value) => print("Event Added"))
        .catchError((error) => print("Failed to add event: $error"));
  }

  Future<void> getAndFetchEvents() async {
    var snapshot = await FirebaseFirestore.instance.collection('event').get();
    var dataAll = snapshot.docs.map((doc) => doc.data()).toList();
    final List<Event> loadedEvents = [];

    dataAll.forEach((event) async {
      var newEvent = new Event(
          eventId: event['eventId'],
          name: event['name'],
          manager: event['manager'],
          managerId: event['managerId'],
          date: event['date'].toDate(),
          // date: DateTime.now(),
          location: 'teste',
          description: event['description']);
      loadedEvents.add(newEvent);
    });

    _eventList = loadedEvents;
    notifyListeners();
  }
}
