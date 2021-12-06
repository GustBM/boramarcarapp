import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/controllers/events_controller.dart';
import 'package:boramarcarapp/models/event.dart';
import 'package:boramarcarapp/widgets/empty_message_widget.dart';
import 'package:boramarcarapp/widgets/event/event_item.dart';

class EventGrid extends StatefulWidget {
  @override
  _EventGridState createState() => _EventGridState();
}

class _EventGridState extends State<EventGrid> {
  List<Event> _eventsData = [];
  List<Event> _allEventsData = [];

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _allEventsData =
          Provider.of<EventController>(context, listen: false).eventsList;
      setState(() {
        _eventsData = _allEventsData;
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Event> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allEventsData;
    } else {
      results = _allEventsData
          .where((event) =>
              event.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _eventsData = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
              labelText: 'Procurar Evento',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
              filled: true,
            ),
          ),
        ),
        SizedBox(height: 10),
        _eventsData.length > 0
            ? Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _eventsData.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: _eventsData[i],
                    child: EventItem(),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              )
            : Center(
                child: EmptyMessage(
                  buttonFunction: () =>
                      Navigator.of(context).pushReplacementNamed('/new-event'),
                  icon: Icons.event,
                  buttonText: 'Novo Evento',
                  messageText: 'Você não está convidado a nenhum evento.',
                  subMessage:
                      'Lembrete: Mantenha o seu horário atualizado antes de criar ou entrar em eventos.',
                ),
              ),
      ],
    );
  }
}
