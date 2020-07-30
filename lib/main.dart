import 'package:app_manager/app_lists.dart';
import 'package:app_manager/search.dart';
import 'package:app_manager/favorite.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_manager/model/app_info_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Main extends StatefulWidget {
  const Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  // チュートリアル表示後かどうかの State を用意
  bool _afterOverBoad = false;
  GlobalKey mainKey = GlobalKey();

  AppInfoModel appInfo;
  int currentPage = 0;
  l.Location _locationService = l.Location();

  // 現在位置
  l.LocationData _yourLocation;

  LatLng _position;

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
        return AppLists(
            viewType: _viewType, getAppsFunction: _getNearLocationApps());
      case 1:
        return Search(getAppsFunction: _getAppsFunction);
      case 2:
        return Favorite();
    }
  }

  Future<List<AppInfoModel>> _getNearLocationApps() async {
    List<AppInfoModel> apps = await _getAppsFunction;
    LatLng nowPosition =
        LatLng(_yourLocation.latitude, _yourLocation.longitude);
    return apps
        .where((app) => haversineDistance(app.position, nowPosition) < 0.5)
        .toList();
  }

  @override
  void initState() {
    super.initState();

    // 現在位置の取得
    _getLocation();

//    _position = appInfo.position;

    // フィールド名の変更
    _getApplicationFunction = DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
  }

  double haversineDistance(LatLng mk1, LatLng mk2) {
    // Radius of the Earth in Kilometers
    var R = 6371.0710;
    // 角度（ radians ）に変換
    var latitudeRadians1 = mk1.latitude * (pi / 180);
    var latitudeRadians2 = mk2.latitude * (pi / 180);
    // 緯度の角度差を求める
    var diffLatitude = latitudeRadians2 - latitudeRadians1;
    // 軽度の角度差を求める
    var diffLongitude = (mk2.longitude - mk1.longitude) * (pi / 180);
    // 2点間の距離を計算する
    var d = 2 *
        R *
        asin(sqrt(sin(diffLatitude / 2) * sin(diffLatitude / 2) +
            cos(latitudeRadians1) *
                cos(latitudeRadians2) *
                sin(diffLongitude / 2) *
                sin(diffLongitude / 2)));
    return d;
  }

  @override
  Widget build(BuildContext context) {
    // 位置情報の取得はビルドのたびに⾏う（変更を検知できるように）
    _getAppsFunction = _getApps();

    // チュートリアル用の Scaffold ウィジェット
    final overBoard = Scaffold(
      key: mainKey,
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          setState(() {
            _afterOverBoad = true;
          });
        },
        finishCallback: () {
          setState(() {
            _afterOverBoad = true;
          });
        },
      ),
    );

    return _afterOverBoad
        ? Scaffold(
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
                          icon: Icon(_viewType == 'grid'
                              ? Icons.view_list
                              : Icons.apps),
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
          )
        : overBoard;
  }

  final pages = [
    PageModel(
        color: const Color(0xFFF9C270),
        imageAssetPath: 'assets/tutorial/tutorial1.png',
        title: 'アプリにメモ！',
        body: 'アプリに関する言葉や店名をメモしよう。',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xFFA5D4AD),
        imageAssetPath: 'assets/tutorial/tutorial2.png',
        title: '位置情報を登録！',
        body: 'アプリを使う場所の位置情報を登録しよう。',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xFFE7D5E8),
        imageAssetPath: 'assets/tutorial/tutorial3.png',
        title: 'アプリを起動！',
        body: '現在位置から近くで使えるアプリが home に表示されるよ。',
        doAnimateImage: true),
    PageModel.withChild(
        child: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Image.asset('assets/tutorial/tutorial4.png', width: 400.0, height: 400.0),
        ),
        color: const Color(0xFFFBDAC8),
        doAnimateChild: true)
  ];
}
