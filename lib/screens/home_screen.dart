import 'package:boramarcarapp/screens/event/event_new_screen.dart';
import 'package:boramarcarapp/screens/schedule/schedule_screen.dart';
import 'package:boramarcarapp/screens/settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/widgets/event/event_grid.dart';
import 'package:boramarcarapp/widgets/notification/notification_badge.dart';

import 'group/groups_screen.dart';

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
  // late int _totalNotifications;
  // ignore: unused_field
  late FirebaseMessaging _messaging;
  int _currentIndex = 2;

  @override
  void initState() {
    // _totalNotifications = 0;
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

  final List<Widget> _screens = [
    GroupsScreen(),
    SchedueleScreen(),
    HomeScreenBody(),
    EventFormScreen(),
    SettingsScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 2
          ? AppBar(
              automaticallyImplyLeading: false,
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
            )
          : null,
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
          primaryColor: Theme.of(context).primaryColor,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color(0xFFFFFFFF),
          currentIndex: _currentIndex,
          showUnselectedLabels: false,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Grupos'),
            BottomNavigationBarItem(
                icon: Icon(Icons.event), label: 'Meu Horário'),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Tela Inicial'),
            BottomNavigationBarItem(
                icon: Icon(Icons.event_available), label: 'Novo Evento'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Configurações'),
          ],
        ),
      ),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          Provider.of<Events>(context, listen: false).refresh(context, userId),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryTextTheme.button!.color,
                      )),
                ),
              ],
            ));
          } else {
            return EventGrid();
          }
        },
      ),
    );
  }
}
