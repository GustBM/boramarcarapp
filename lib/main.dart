import 'package:boramarcarapp/widgets/date_range_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(BoraMarcarApp());

/*class BoraMarcarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: []);
  }
}*/

class BoraMarcarApp extends StatelessWidget {
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
        body: SafeArea(child: DateRangeSelector()),
      ),
    );
  }
}
