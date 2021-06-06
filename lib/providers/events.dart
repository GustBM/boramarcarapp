import 'dart:convert';

import 'package:boramarcarapp/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Events extends ChangeNotifier {
  final String authToken;
  List<Event> _previousEvents = [];

  Events(this.authToken, this._previousEvents);

  List<Event> _eventList = [
    Event(
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
  ];

  List<Event> get eventsList {
    return [..._eventList];
  }

  Event findById(String eventId) {
    return _eventList.firstWhere((element) => element.eventId == eventId);
  }

  Future<void> addNewEvent(Event event) async {
    final url = Uri.https(
        'flutter-update.firebaseio.com', '/events.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'date': event.date,
          'description': event.description,
          'location': event.location,
          'manager': event.location,
          'managerId': event.managerId,
          'name': event.name,
        }),
      );
      final newEvent = Event(
        date: event.date,
        description: event.description,
        eventId: json.decode(response.body)['name'],
        location: event.location,
        manager: event.location,
        managerId: event.managerId,
        name: event.name,
      );
      _eventList.add(newEvent);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
