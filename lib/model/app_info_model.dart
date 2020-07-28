import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppInfoModel {
  Uint8List _icon;
  String _name;
  String _memo;

  Uint8List get icon => _icon;

  String get name => _name;

  String get memo => _memo;

  void setIcon(Uint8List icon) => _icon = icon;

  void setName(String name) => _name = name;

  void setMemo(String memo) => _memo = memo;

  // フィールド、Getter、Setterの3点セット
  LatLng _position;

  LatLng get position => _position;

  void setPosition(LatLng position) => _position = position;

  // フィールド、Getter、Setterの3点セット
  String _packageName;

  String get packageName => _packageName;

  void setPackageName(String packageName) => _packageName = packageName;

  AppInfoModel({
    Uint8List icon,
    String name,
    String packageName,
    String memo,
    LatLng position,
  })  : _icon = icon,
        _name = name,
        _packageName = packageName,
        _memo = memo,
        _position = position;
}
