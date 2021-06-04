import 'package:boramarcarapp/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/auth.dart';
import 'package:boramarcarapp/screens/home_screen.dart';
import 'package:boramarcarapp/screens/splash_screen.dart';

void main() => runApp(BoraMarcarApp());

Map<int, Color> colorCodes = {
  50: Color.fromRGBO(147, 205, 72, .1),
  100: Color.fromRGBO(147, 205, 72, .2),
  200: Color.fromRGBO(147, 205, 72, .3),
  300: Color.fromRGBO(147, 205, 72, .4),
  400: Color.fromRGBO(147, 205, 72, .5),
  500: Color.fromRGBO(147, 205, 72, .6),
  600: Color.fromRGBO(147, 205, 72, .7),
  700: Color.fromRGBO(147, 205, 72, .8),
  800: Color.fromRGBO(147, 205, 72, .9),
  900: Color.fromRGBO(147, 205, 72, 1),
};

/*class BoraMarcarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BoraMarcar',
      supportedLocales: [const Locale('pt', 'BR')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text("Exemplo"),
        ),
        body: DateRangeForm(),
      ),
    );
  }
}*/

class BoraMarcarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        /*ChangeNotifierProxyProvider<Auth, Attainments>(
          create: null,
          update: (ctx, auth, previousAttainments) => Attainments(
              auth.token,
              previousAttainments == null
                  ? []
                  : previousAttainments.attainmentList),
        ),*/
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
              primarySwatch: MaterialColor(0xFF990000, colorCodes),
              accentColor: Colors.blueGrey[200],
              fontFamily: 'Lato',
              canvasColor: Colors.white,
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoAuth(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              HomeScreen.routeName: (ctx) => HomeScreen(),
            }),
      ),
    );
  }
}
