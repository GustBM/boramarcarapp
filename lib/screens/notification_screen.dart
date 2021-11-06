import 'package:boramarcarapp/models/notification.dart';
import 'package:boramarcarapp/providers/notifications.dart';
import 'package:boramarcarapp/widgets/empty_message_widget.dart';
import 'package:boramarcarapp/widgets/notification/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final User? _userInfo = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<AppNotification>>(
          future: Provider.of<AppNotifications>(context).getUserNotifications,
          builder: (BuildContext context,
              AsyncSnapshot<List<AppNotification>> snapshot) {
            if (snapshot.hasError) {
              return SnapshotErroMsg(
                  'Houve um erro ao buscar o as suas notificações.\nTente novamente mais tarde.');
            }

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return EmptyMessage(
                icon: Icons.notifications,
                messageText: "Nenhuma Notificação encontrada.",
                buttonFunction: () => Navigator.of(context).pop(),
                buttonText: 'Voltar',
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot);
              List<AppNotification> notifications = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) =>
                      NotificationCard(notifications[index]),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
