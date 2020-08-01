import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Manager',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: TextTheme(
          headline1: GoogleFonts.mPLUS1p(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            textStyle: TextStyle(letterSpacing: -1.5, height: -1.0),
          ),
          headline2: GoogleFonts.mPLUS1p(
              fontSize: 60,
              fontWeight: FontWeight.w300,
              textStyle: TextStyle(letterSpacing: -0.5, height: 1.0)),
          headline3: GoogleFonts.mPLUS1p(
              fontSize: 48,
              fontWeight: FontWeight.w400,
              textStyle: TextStyle(letterSpacing: 0.0, height: 1.0)),
          headline4: GoogleFonts.mPLUS1p(
              fontSize: 34,
              fontWeight: FontWeight.w400,
              textStyle: TextStyle(letterSpacing: 0.25, height: 1.0)),
          headline5: GoogleFonts.mPLUS1p(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              textStyle: TextStyle(letterSpacing: 0.0, height: 1.0)),
          headline6: GoogleFonts.mPLUS1p(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              textStyle: TextStyle(letterSpacing: 0.15, height: 1.0)),
          subtitle1: GoogleFonts.mPLUS1p(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textStyle: TextStyle(letterSpacing: 0.15, height: 1.0)),
          subtitle2: GoogleFonts.mPLUS1p(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textStyle: TextStyle(letterSpacing: 0.1, height: 1.0)),
          bodyText1: GoogleFonts.mPLUS1p(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textStyle: TextStyle(letterSpacing: 0.5, height: 1.0)),
          bodyText2: GoogleFonts.mPLUS1p(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textStyle: TextStyle(letterSpacing: 0.25, height: 1.0)),
        ),
      ),
      home: Main(title: 'App Manager'),
    );
  }
}
