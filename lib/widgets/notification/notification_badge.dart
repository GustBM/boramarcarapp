import 'package:boramarcarapp/providers/notifications.dart';
import 'package:boramarcarapp/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: <Widget>[
          new Icon(Icons.notifications),
          Positioned(
            right: 0,
            child: new Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: FutureBuilder(
                future: Provider.of<AppNotifications>(context)
                    .getUnreadNotificationsNumber,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData && snapshot.data! > 0) {
                    var totalNotifications = snapshot.data!;
                    return Text(
                      '$totalNotifications',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else
                    return SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => NotificationScreen(),
          ),
        )
      },
    );
  }
}
