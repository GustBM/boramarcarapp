import 'package:boramarcarapp/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/screens/event_detail_screen.dart';

class EventItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              EventDetailScreen.routeName,
              arguments: event.eventId,
            );
          },
          child: event.imageUrl == ''
              ? Image.asset(
                  'assets/images/baloes.jpg',
                  fit: BoxFit.cover,
                )
              : Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            event.name,
            textAlign: TextAlign.left,
          ),
          subtitle: Text(event.date.day.toString() +
              '/' +
              event.date.month.toString() +
              '/' +
              event.date.year.toString()),
        ),
      ),
    );
  }
}
