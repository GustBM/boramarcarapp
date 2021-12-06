import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/event.dart';
import 'package:boramarcarapp/view/event/event_detail_screen.dart';

class EventItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _event = Provider.of<Event>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          EventDetailScreen.routeName,
          arguments: _event.eventId,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: _event.imageUrl == '' || _event.imageUrl == null
              ? Hero(
                  tag: _event.eventId,
                  child: Image.asset(
                    'assets/images/baloes.jpg',
                    fit: BoxFit.cover,
                  ),
                )
              : Hero(
                  tag: _event.eventId,
                  child: Image.network(
                    _event.imageUrl!,
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
      ),
    );
  }
}
