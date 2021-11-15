import 'package:flutter/material.dart';

final base = ThemeData.light();
final mainColor = Color(0xFF8597AD);
final secondaryColor = Color(0xFFFFFFFF);

ThemeData get appThemeData => ThemeData(
      brightness: Brightness.light,
      primaryColor: mainColor,
      fontFamily: 'Lato',
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 23.0),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(primary: mainColor, secondary: secondaryColor),
      cardColor: Color.lerp(Colors.white, Colors.white, 0.2),
      cardTheme: base.cardTheme.copyWith(
        color: Colors.white, // Color.lerp(Colors.white, Colors.black, 0.1),
        margin: EdgeInsets.all(20.0),
        elevation: 0.0,
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
            side: BorderSide(color: Colors.white24, width: 1)),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: mainColor,
        textTheme: ButtonTextTheme.accent,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            primary: mainColor,
            backgroundColor: Colors.white70,
            side: BorderSide(width: 3, color: mainColor),
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            textStyle: TextStyle(fontSize: 20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
          primary: mainColor,
          textStyle: TextStyle(color: secondaryColor, fontSize: 20),
        ),
      ),
    );
