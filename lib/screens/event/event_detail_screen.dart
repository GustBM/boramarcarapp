import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/providers/events.dart';

class EventDetailScreen extends StatelessWidget {
  static const routeName = '/event-detail';

  @override
  Widget build(BuildContext context) {
    final eventId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedEvent =
        Provider.of<Events>(context, listen: false).findById(eventId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedEvent.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              child: loadedEvent.imageUrl == ''
                  ? Image.asset(
                      'assets/images/baloes.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      loadedEvent.imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 10),
            Text(
              loadedEvent.name,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedEvent.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
