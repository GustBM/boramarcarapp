import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/controllers/auth_controller.dart';
import 'package:boramarcarapp/controllers/events_controller.dart';
import 'package:boramarcarapp/controllers/groups_controller.dart';
import 'package:boramarcarapp/controllers/notifications_controller.dart';
import 'package:boramarcarapp/controllers/schedules_controller.dart';
import 'package:boramarcarapp/controllers/users_controller.dart';
import 'package:boramarcarapp/view/auth_screen.dart';
import 'package:boramarcarapp/view/home_screen.dart';
import 'package:boramarcarapp/view/splash_screen.dart';
import 'package:boramarcarapp/view/event/event_detail_screen.dart';
import 'package:boramarcarapp/view/event/event_new_screen.dart';
import 'package:boramarcarapp/view/settings/settings_screen.dart';
import 'package:boramarcarapp/view/schedule/schedule_screen.dart';
import 'package:boramarcarapp/view/settings/edit_user_info_screen.dart';
import 'package:boramarcarapp/view/group/group_details_screen.dart';
import 'package:boramarcarapp/view/group/groups_screen.dart';
import 'package:boramarcarapp/view/group/group_new_screen.dart';

import 'package:boramarcarapp/theme_data.dart';

import 'key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(BoraMarcarApp());
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

class BoraMarcarApp extends StatefulWidget {
  @override
  State<BoraMarcarApp> createState() => _BoraMarcarAppState();
}

class _BoraMarcarAppState extends State<BoraMarcarApp> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();

    OneSignal.shared.setAppId(ApiKeys.ONE_SIGNAL_KEY);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthController(),
        ),
        ChangeNotifierProvider<EventController>(
          create: (_) => EventController(),
        ),
        ChangeNotifierProvider<ScheduleController>(
          create: (_) => ScheduleController(),
        ),
        ChangeNotifierProvider<UserController>(
          create: (_) => UserController(),
        ),
        ChangeNotifierProvider<GroupController>(
          create: (_) => GroupController(),
        ),
        ChangeNotifierProvider<AppNotificationController>(
          create: (_) => AppNotificationController(),
        ),
      ],
      child: Consumer<AuthController>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BoraMarcar',
          supportedLocales: [const Locale('pt', 'BR')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          theme: appThemeData,
          home: FutureBuilder(
              future: _fbApp,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Erro! ${snapshot.error.toString()}');
                  return Text("Houve um erro na conexão com o banco!");
                } else if (snapshot.hasData) {
                  return auth.isAuth
                      ? FutureBuilder(
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : HomeScreen())
                      : AuthScreen();
                } else {
                  return SplashScreen();
                }
              }),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            EventDetailScreen.routeName: (ctx) => EventDetailScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            EventFormScreen.routeName: (ctx) => EventFormScreen(),
            SchedueleScreen.routeName: (ctx) => SchedueleScreen(),
            EditUserInfoScreen.routeName: (ctx) => EditUserInfoScreen(),
            GroupsScreen.routeName: (ctx) => GroupsScreen(),
            NewGroupScreen.routeName: (ctx) => NewGroupScreen(),
            GroupDetailsScreen.routeName: (ctx) => GroupDetailsScreen(),
          },
        ),
      ),
    );
  }
}
