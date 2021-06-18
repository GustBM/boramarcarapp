import 'package:boramarcarapp/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Events extends ChangeNotifier {
  late final String? authToken;
  // List<Event>? _previousEvents = [];
  CollectionReference events = FirebaseFirestore.instance.collection('event');

  // Events(this.authToken, this._previousEvents);

  List<Event> _eventList = [];

  List<Event> get eventsList {
    return [..._eventList];
  }

  Event findById(String eventId) {
    return _eventList.firstWhere((element) => element.eventId == eventId);
  }

  Future<void> update() async {
    notifyListeners();
  }

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
