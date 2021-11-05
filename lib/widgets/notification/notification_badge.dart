import 'package:boramarcarapp/screens/notification_screen.dart';
import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: <Widget>[
          new Icon(Icons.notifications),
          totalNotifications > 0
              ? new Positioned(
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
                    child: new Text(
                      '$totalNotifications',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SizedBox(),
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
