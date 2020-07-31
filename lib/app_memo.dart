import 'package:app_manager/model/app_info_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMemo extends StatefulWidget {
  final AppInfoModel appInfo;
  final bool editMode;

  const AppMemo({Key key, this.appInfo, this.editMode}) : super(key: key);

  @override
  _AppMemoState createState() => _AppMemoState();
}

class _AppMemoState extends State<AppMemo> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
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
    _memo = widget.appInfo.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 50.0),
      child: widget.editMode
          ? TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'ﾒﾓﾒﾓ _φ(･_･'),
              onChanged: _saveMemo,
            )
          : Text(
              (_memo == null || _memo.isEmpty)
                  ? 'このアプリのメモは登録されてないみたいだよ (¯―¯٥)'
                  : _memo,
              style: GoogleFonts.mPLUS1p(
                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6)),
                fontSize: 20.0,
              ),
            ),
    );
  }
}
