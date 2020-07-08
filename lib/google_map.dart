import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleMap extends StatefulWidget {
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Google Map',
            style: GoogleFonts.kanit(
              textStyle: TextStyle(
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        body: Placeholder());
  }
}
