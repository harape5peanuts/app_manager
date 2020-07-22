import 'package:app_manager/model/app_info.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMemo extends StatefulWidget {
  final Application appInfo;
  final bool editMode;

  const AppMemo({Key key, this.appInfo, this.editMode}) : super(key: key);

  @override
  _AppMemoState createState() => _AppMemoState();
}

class _AppMemoState extends State<AppMemo> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _appMemo;
  TextEditingController _controller;
  String _memo = null;

  Future<void> _saveMemo(newValue) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(widget.appInfo.packageName, newValue);

    setState(() {
      _memo = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    _appMemo = _prefs.then((SharedPreferences prefs) {
      var memo = (prefs.getString(widget.appInfo.packageName) ?? '');
      _controller = TextEditingController(text: memo);
      return memo;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_memo == null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 50.0),
        child: FutureBuilder(
          // `device_apps` パッケージを利用して端末にインストールされているアプリの一覧を取得している
          future: _appMemo,
          builder: (context, data) {
            // 非同期処理中の判断
            if (data.data == null) {
              // データ取得前はローディング中のプログレスを表示
              return Center(
                child: const CircularProgressIndicator(),
              );
            } else {
              final memo = data.data as String;
              return widget.editMode
                  ? TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'ﾒﾓﾒﾓ _φ(･_･'),
                onChanged: _saveMemo,
              )
                  : Text(
                memo == '' ? 'このアプリのメモは登録されてないみたいだよ (¯―¯٥)' : memo,
                style: GoogleFonts.mPLUS1p(
                  textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6)),
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              );
            }
          },
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 50.0),
        child: widget.editMode
            ? TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'ﾒﾓﾒﾓ _φ(･_･'),
          onChanged: _saveMemo,
        )
            : Text(
          _memo,
          style: GoogleFonts.mPLUS1p(
            textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6)),
            fontSize: 20.0,
          ),
        ),
      );
    }
  }
}
