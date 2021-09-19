import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/widgets/app_drawer.dart';
import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/widgets/event/event_grid.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'BoraMarcar',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'Klavika',
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Notificações
              // Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
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
