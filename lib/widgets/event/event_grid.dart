import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/widgets/event/event_item.dart';

class EventGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventsData = Provider.of<Events>(context).eventsList;

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: eventsData.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: eventsData[i],
          child: EventItem(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
