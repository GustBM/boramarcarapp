import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/widgets/app_drawer.dart';
import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/widgets/event/event_grid.dart';
import 'package:boramarcarapp/widgets/notification/notification_badge.dart';

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _totalNotifications;
  // ignore: unused_field
  late FirebaseMessaging _messaging;

  @override
  void initState() {
    _totalNotifications = 0;
    // _messaging = FirebaseMessaging.instance;
    // _messaging.getToken().then((value) {
    //   print(value);
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      showSimpleNotification(Text(event.notification!.title!),
          leading: NotificationBadge(),
          subtitle: Text(event.notification!.body!),
          background: Theme.of(context).primaryColor,
          duration: Duration(seconds: 120),
          slideDismissDirection: DismissDirection.vertical);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'BoraMarcar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Klavika',
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
        actions: <Widget>[
          NotificationBadge(),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Events>(context, listen: false)
            .refresh(context, userId),
        child: FutureBuilder(
          future: Provider.of<Events>(context, listen: false)
              .refresh(context, userId),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Text(
                    'Houve um erro ao tentar\nbuscar os Eventos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text('Recarregar'),
                    onPressed: () => {
                      Provider.of<Events>(context, listen: false)
                          .refresh(context, userId)
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        primary: Theme.of(context).primaryColor,
                        textStyle: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.button!.color,
                        )),
                  ),
                ],
              ));
            } else {
              return EventGrid();
            }
          },
        ),
      ),
    );
  }
}
