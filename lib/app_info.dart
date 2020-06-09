import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInfo extends StatefulWidget {
  final Application appInfo;
  final Uint8List appIcon;

  const AppInfo({Key key, @required this.appInfo, this.appIcon})
      : super(key: key);

  @override
  _AppInfoState createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  bool _editMode = false;

  void _toggleViewType() {
    setState(() {
      if (_editMode) {
        _editMode = false;
      } else {
        _editMode = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _style = Theme.of(context)
        .textTheme
        .display1
        .apply(color: Color.fromRGBO(0, 0, 0, 0.9));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Info',
          style: GoogleFonts.kanit(
            textStyle: TextStyle(
              decoration: TextDecoration.none,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () => _toggleViewType(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.appInfo.appName,
                  style: GoogleFonts.kanit(
                    textStyle: _style,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 50.0),
                  child: _editMode
                      ? TextField(
                          decoration: InputDecoration(hintText: 'ﾒﾓﾒﾓ _φ(･_･'),
                        )
                      : Text(
                          widget.appInfo.appName,
                          style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6)
                            ),
                            fontSize: 20.0,
                          ),
                        ),
                ),
                Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 50,
                          height: 50,
                          child: Image.memory(widget.appIcon)),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
