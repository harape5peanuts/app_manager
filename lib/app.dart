import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
        textTheme: TextTheme(
          headline1: GoogleFonts.mPLUS1p(fontSize: 96),
          headline2: GoogleFonts.mPLUS1p(fontSize: 60),
          headline3: GoogleFonts.mPLUS1p(fontSize: 48),
          headline4: GoogleFonts.mPLUS1p(fontSize: 34),
          headline5: GoogleFonts.mPLUS1p(fontSize: 24),
          headline6: GoogleFonts.mPLUS1p(fontSize: 20),
          subtitle1: GoogleFonts.mPLUS1p(fontSize: 16),
          subtitle2: GoogleFonts.mPLUS1p(fontSize: 14),
          bodyText1: GoogleFonts.mPLUS1p(fontSize: 16),
          bodyText2: GoogleFonts.mPLUS1p(fontSize: 14),
        ),
      ),

      home: Main(title: 'APP MANAGER'),

    );
  }
}
