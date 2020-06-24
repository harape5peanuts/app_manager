import 'dart:typed_data';

class AppInfo {
  Uint8List _icon;
  String _name;
  String _memo;

  Uint8List get icon => _icon;
  String get name => _name;
  String get memo => _memo;

  void setIcon(Uint8List icon) => _icon = icon;
  void setName(String name) => _name = name;
  void setMemo(String memo) => _memo = memo;

  AppInfo({
    Uint8List icon,
    String name,
    String memo,
  })  : _icon = icon,
        _name = name,
        _memo = memo;
}
