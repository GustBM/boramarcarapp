import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/providers/auth.dart';
import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/providers/groups.dart';
import 'package:boramarcarapp/providers/schedules.dart';
import 'package:boramarcarapp/providers/users.dart';
import 'package:boramarcarapp/screens/home_screen.dart';
import 'package:boramarcarapp/screens/splash_screen.dart';
import 'package:boramarcarapp/screens/auth_screen.dart';
import 'package:boramarcarapp/screens/event/event_detail_screen.dart';
import 'package:boramarcarapp/screens/event/event_new_screen.dart';
import 'package:boramarcarapp/screens/settings/settings_screen.dart';
import 'package:boramarcarapp/screens/schedule_screen.dart';
import 'package:boramarcarapp/screens/settings/edit_user_info_screen.dart';
import 'package:boramarcarapp/screens/group/group_details_screen.dart';
import 'package:boramarcarapp/screens/group/groups_screen.dart';
import 'package:boramarcarapp/screens/group/group_new_screen.dart';
import 'package:boramarcarapp/theme_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BoraMarcarApp());
}

class BoraMarcarApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider<Events>(
          create: (_) => Events(),
        ),
        ChangeNotifierProvider<Schedules>(
          create: (_) => Schedules(),
        ),
        ChangeNotifierProvider<Users>(
          create: (_) => Users(),
        ),
        ChangeNotifierProvider<Groups>(
          create: (_) => Groups(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
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
