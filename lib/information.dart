import 'dart:typed_data';

import 'package:app_manager/app_memo.dart';
import 'package:app_manager/google_map_view.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information extends StatefulWidget {
  final Application appInfo;
  final Uint8List appIcon;

  const Information({Key key, @required this.appInfo, this.appIcon})
      : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<LatLng> _appPosition;

  LatLng _position;
  bool _editMode = false;

  void _toggleViewType() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  Future<void> _savePosition(newValue) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setDouble(
        widget.appInfo.packageName + '-position-latitude', newValue.latitude);
    prefs.setDouble(
        widget.appInfo.packageName + '-position-longitude', newValue.longitude);

    setState(() {
      _position = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    _appPosition = _prefs.then((SharedPreferences prefs) {
      var latitude =
          (prefs.getDouble(widget.appInfo.packageName + '-position-latitude') ??
              0);
      var longitude = (prefs
              .getDouble(widget.appInfo.packageName + '-position-longitude') ??
          0);
      var position = LatLng(latitude, longitude);
      return position;
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
              AppMemo(appInfo: widget.appInfo, editMode: _editMode),
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 50,
                      height: 50,
                      child: Image.memory(widget.appIcon),
                    ),
                  ),
                ),
              ),
              Text(
                '位置情報',
                style: GoogleFonts.kanit(
                  textStyle: Theme.of(context).textTheme.headline6,
                ),
              ),
              FutureBuilder(
                future: _appPosition,
                builder: (context, data) {
                  if (data == null) {
                    // データ取得前はローディング中のプログレスを表示
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  } else {
                    _position = data.data;
                    if (_position != null) {
                      final latitude = _position?.latitude;
                      final longitude = _position?.longitude;

                      return Center(
                        child: Text(
                          '緯度 : $latitude / 経度 : $longitude',
                          style: GoogleFonts.kanit(
                            textStyle: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          '未設定',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _editMode
          ? FloatingActionButton(
              child: Icon(Icons.place),
              onPressed: () {
                Navigator.push(
                  this.context,
                  MaterialPageRoute(
                    builder: (context) => GoogleMapView(
                      position: _position,
                    ),
                  ),
                ).then((value) {
                  _savePosition(value);
                });
              },
            )
          : null,
    );
  }
}
