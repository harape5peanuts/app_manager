import 'package:app_manager/app_memo.dart';
import 'package:app_manager/google_map_view.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_manager/model/app_info_model.dart';

class Information extends StatefulWidget {
  final AppInfoModel appInfo;

  const Information({Key key, @required this.appInfo}) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    // like ボタン押したタイミングで SharedPreference に保存
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(widget.appInfo.packageName + '-fav', !isLiked);
    // アプリ情報モデルも更新
    widget.appInfo.setFav(!isLiked);
    return !isLiked;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_position == null) {
      _position = widget.appInfo.position;
    }
    final latitude = _position?.latitude;
    final longitude = _position?.longitude;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'App Info',
          style: GoogleFonts.mPLUS1p(
            textStyle: TextStyle(
              color: Colors.white,
            ),
            fontWeight: FontWeight.bold,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Text(
                      widget.appInfo.name,
                      style: GoogleFonts.mPLUS1p(
                        textStyle: TextStyle(
                          height: 1.3,
                        ),
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: LikeButton(
                      // 初期値はアプリ情報モデルのもの
                      isLiked: widget.appInfo.fav,
                      // タップ時のイベントは上で追加したメソッド
                      onTap: onLikeButtonTapped,
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xfffcea6b),
                        dotSecondaryColor: Color(0xfffbe340),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.star,
                          color: isLiked ? Colors.amber : Colors.grey,
                        );
                      },
                    ),
                  ),
                ],
              ),
              AppMemo(appInfo: widget.appInfo, editMode: _editMode),
              Center(
                child: GestureDetector(
                  onTap: () => DeviceApps.openApp(widget.appInfo.packageName),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 50,
                        height: 50,
                        child: Image.memory(widget.appInfo.icon),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                child: Divider(
                  color: Colors.amber,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 10.0),
                child: Text(
                  '位置情報',
                  style: GoogleFonts.mPLUS1p(
                    textStyle: Theme.of(context).textTheme.headline5,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              _position != null
                  ? Center(
                      child: Text(
                        '緯度 : $latitude\n経度 : $longitude',
                        style: GoogleFonts.mPLUS1p(
                          textStyle: TextStyle(height: 1.3),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        '未設定',
                        style: GoogleFonts.mPLUS1p(
                          textStyle: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: _editMode
          ? FloatingActionButton(
              child: Icon(
                Icons.place,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  this.context,
                  MaterialPageRoute(
                    builder: (context) => GoogleMapView(
                      position: _position,
                    ),
                  ),
                ).then((value) {
                  setState(() {
                    _position = value;
                    widget.appInfo.setPosition(value);
                  });
                  _savePosition(value);
                });
              },
            )
          : null,
    );
  }
}
