import 'package:boramarcarapp/providers/schedules.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:boramarcarapp/screens/event/event_detail_screen.dart';
import 'package:boramarcarapp/models/event.dart';
import 'package:boramarcarapp/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class Events extends ChangeNotifier {
  CollectionReference _events = FirebaseFirestore.instance.collection('event');

  List<Event> _eventList = [];

  List<Event> get eventsList {
    return [..._eventList];
  }

  Future<DocumentSnapshot<Event>> getEvent(String eventId) async {
    return _events
        .doc(eventId)
        .withConverter<Event>(
            fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
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
      // print(user);
      usersId.add(user);
    }).then((value) async {
      var dateRange = new DateTimeRange(start: dateIni, end: dateEnd);
      bestDates = await Provider.of<Schedules>(context, listen: false)
          .getIdealDate(dateRange, usersId);
    }).then((dates) {
      final eventId = getRandomString(20);
      return _events
          .doc(eventId)
          .set({
            'eventId': eventId,
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
          .then((value) => goToEvent(context, eventId, managerId, invited))
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

  Future<void> refresh(BuildContext context, String userId) async {
    try {
      await _getAndFetchEvents(userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Houve um erro ao buscar eventos. Tente novamente mais tarde."),
      ));
    }
  }

  Future<void> _getAndFetchEvents(String uid) async {
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
        location: event['location'],
        description: event['description'],
        imageUrl: event['imageUrl'],
      );
      loadedEvents.add(newEvent);
    });

    _eventList = loadedEvents;
    notifyListeners();
  }
}
