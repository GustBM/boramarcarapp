import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/providers/auth.dart';
import 'package:boramarcarapp/screens/home_screen.dart';
import 'package:boramarcarapp/screens/splash_screen.dart';
import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/providers/schedules.dart';
import 'package:boramarcarapp/screens/auth_screen.dart';
import 'package:boramarcarapp/screens/event/event_detail_screen.dart';
import 'package:boramarcarapp/screens/event/event_new_screen.dart';
import 'package:boramarcarapp/screens/settings_screen.dart';
import 'package:boramarcarapp/screens/schduele_screen.dart';
import 'package:boramarcarapp/screens/edit_user_info_screen.dart';

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
          // update: (ctx, auth, previousEvents) => previousEvents!..update(),
        ),
        ChangeNotifierProvider<Schedules>(
          create: (_) => Schedules(),
          // update: (ctx, auth, previousEvents) => previousEvents!..update(),
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
          theme: ThemeData(
            brightness: Brightness.light,
            // primaryColor: Colors.amber[400],
            primaryColor: Color(0xFF5f65d3),
            // accentColor: Color.fromRGBO(82, 104, 143, 1),
            accentColor: Colors.amber[400],
            fontFamily: 'Lato',
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
          ),
          home: FutureBuilder(
              future: _fbApp,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Erro! ${snapshot.error.toString()}');
                  return Text("Houve um erro!");
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
          },
        ),
      ),
    );
  }
}
