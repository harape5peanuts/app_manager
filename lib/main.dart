import 'package:app_manager/app_lists.dart';
import 'package:app_manager/search.dart';
import 'package:app_manager/favorite.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_manager/model/app_info_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();
  String _viewType = 'grid';
//  Future<List<Application>> _getAppsFunction;
  Future<List<Application>> _getApplicationFunction;
  Future<List<AppInfoModel>> _getAppsFunction;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<AppInfoModel>> _getApps() async {
    List<Application> apps = await _getApplicationFunction;
    List<AppInfoModel> models = [];
    for (var app in apps) {
      final appIcon = app is ApplicationWithIcon
// アイコンを持っているアプリ（ ApplicationWithIcon インスタンス）の場合はアイコンを表⽰する
          ? app.icon
// ない場合はアイコンなし
          : null;
      final position = await _getPosition(app);
      models.add(AppInfoModel(
          name: app.appName,
          packageName: app.packageName,
          icon: appIcon,
          position: position));
    }
    return models;
  }

  Future<LatLng> _getPosition(appInfo) async {
    return _prefs.then((SharedPreferences prefs) {
      var latitude =
          (prefs.getDouble(appInfo.packageName + '-position-latitude') ?? 0);
      var longitude =
          (prefs.getDouble(appInfo.packageName + '-position-longitude') ?? 0);
      var position = LatLng(latitude, longitude);
      return position;
    });
  }

  void _toggleViewType() {
    setState(() {
      if (_viewType == 'lists') {
        _viewType = 'grid';
      } else {
        _viewType = 'lists';
      }
    });
  }

  Widget _getPage(pageNum) {
    switch (pageNum) {
      case 0:
        return AppLists(viewType: _viewType, getAppsFunction: _getAppsFunction);
      case 1:
        return Search(getAppsFunction: _getAppsFunction);
      case 2:
        return Favorite();
    }
  }

  @override
  void initState() {
    super.initState();
    // フィールド名の変更
    _getApplicationFunction = DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 位置情報の取得はビルドのたびに⾏う（変更を検知できるように）
    _getAppsFunction = _getApps();

    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.title,
            style: GoogleFonts.mPLUS1p(
              textStyle: TextStyle(
                decoration: TextDecoration.none,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: currentPage == 0
              ? <Widget>[
                  // AppBar にボタンを用意して表示内容を切り替える処理が書かれている
                  IconButton(
                    icon: Icon(
                        _viewType == 'grid' ? Icons.view_list : Icons.apps),
                    onPressed: () => _toggleViewType(),
                  )
                ]
              : <Widget>[]),
      body: _getPage(currentPage),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.search, title: "Search"),
          TabData(iconData: Icons.star, title: "favorite")
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }
}
