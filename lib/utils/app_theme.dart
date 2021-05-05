import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData theme = ThemeData(
    primaryColor: Color(0xFF000c4f),
    accentColor: Color(0xFFf9ba00),
    scaffoldBackgroundColor: Color(0xFF31c3d6),
    iconTheme: IconThemeData(color: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
    primaryIconTheme: IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'Calibri',
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
      ),
      hintStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'Calibri',
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}
