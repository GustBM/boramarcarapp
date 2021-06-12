import 'package:boramarcarapp/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/screens/event_detail_screen.dart';

class EventItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _event = Provider.of<Event>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              EventDetailScreen.routeName,
              arguments: _event.eventId,
            );
          },
          child: _event.imageUrl == ''
              ? Image.asset(
                  'assets/images/baloes.jpg',
                  fit: BoxFit.cover,
                )
              : Image.network(
                  _event.imageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            _event.name,
            textAlign: TextAlign.left,
          ),
          subtitle: Text(_event.date.day.toString() +
              '/' +
              _event.date.month.toString() +
              '/' +
              _event.date.year.toString()),
        ),
      ),
    );
  }
}
