import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppInfoModel {
  Uint8List _icon;
  String _name;
  String _memo;
  bool _fav;
  LatLng _position;

  Uint8List get icon => _icon;

  String get name => _name;

  String get memo => _memo;

  bool get fav => _fav;

  LatLng get position => _position;

  void setIcon(Uint8List icon) => _icon = icon;

  void setName(String name) => _name = name;

  void setMemo(String memo) => _memo = memo;

  void setFav(bool fav) => _fav = fav;

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
    bool fav,
  })  : _icon = icon,
        _name = name,
        _packageName = packageName,
        _memo = memo,
        _position = position,
        _fav = fav;
}
