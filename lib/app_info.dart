import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Demo Home Page',
          style: GoogleFonts.kanit(
            textStyle: TextStyle(
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
      body: Placeholder(),
    );
  }

}