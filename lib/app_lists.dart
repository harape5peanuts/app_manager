import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_info.dart';

class AppLists extends StatefulWidget {
  AppLists({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AppListsState createState() => _AppListsState();
}

class _AppListsState extends State<AppLists> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();
  String _viewType = 'grid';

  void _toggleViewType() {
    setState(() {
      if (_viewType == 'lists') {
        _viewType = 'grid';
      } else {
        _viewType = 'lists';
      }
    });
  }

  Widget _toggleView(apps) {
    if (_viewType == 'grid') {
      return GridView.builder(
        itemCount: apps.length,
        primary: false,
        padding: const EdgeInsets.all(40),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final app = apps[index];
          final appIcon = app is ApplicationWithIcon
              // アイコンを持っているアプリ（ ApplicationWithIcon インスタンス）の場合はアイコンを表示する
              ? app.icon
              // ない場合はアイコンなし
              : null;
          return Container(
            child: appIcon != null
                // アイコンを持っているアプリ（ ApplicationWithIcon インスタンス）の場合はアイコンを表示する
                ? GestureDetector(
                    // タップした場合は、詳細画面に遷移する
                    onTap: () {
                      Navigator.push(
                        this.context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AppInfo(appInfo: app, appIcon: appIcon),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.memory(appIcon),
                      ),
                    ),
                  )
                // ない場合はアイコンなし
                : null,
          );
        },
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, position) {
          final app = apps[position];
          final appIcon = app is ApplicationWithIcon
              // アイコンを持っているアプリ（ ApplicationWithIcon インスタンス）の場合はアイコンを表示する
              ? app.icon as Uint8List
              // ない場合はアイコンなし
              : null;

          // アプリひとつずつ横並び（ Column ）で情報を表示する
          return Column(
            children: <Widget>[
              ListTile(
                // `x is AnyClass` という記述は Java でいう `x instanceOf AnyClass`
                leading: appIcon != null
                    // アイコンを持っているアプリ（ ApplicationWithIcon インスタンス）の場合はアイコンを表示する
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(appIcon),
                        backgroundColor: Colors.white,
                      )
                    // ない場合はアイコンなし
                    : null,

                // タップした場合は、詳細画面に遷移する
                onTap: () {
                  Navigator.push(
                      this.context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AppInfo(appInfo: app, appIcon: appIcon)));
                },

                // リストタイトルにアプリ名＋パッケージ名を表示
                title: Text("${app.appName}"),

                // リストサブタイトルにバージョンを表示
                subtitle: Text('Version: ${app.versionName}'),
              ),

              // アンダーライン
              Divider(
                height: 1.0,
              )
            ],
          );
        },
        itemCount: apps.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.kanit(
            textStyle: TextStyle(
              decoration: TextDecoration.none,
            ),
          ),
        ),
        actions: <Widget>[
          // AppBar にボタンを用意して表示内容を切り替える処理が書かれている
          IconButton(
            icon: Icon(_viewType == 'grid' ? Icons.view_list : Icons.apps),
            onPressed: () => _toggleViewType(),
          )
        ],
      ),
      body: FutureBuilder(
        // `device_apps` パッケージを利用して端末にインストールされているアプリの一覧を取得している
        future: DeviceApps.getInstalledApplications(
          includeAppIcons: true,
          includeSystemApps: true,
          onlyAppsWithLaunchIntent: true,
        ),
        builder: (context, data) {
          // 非同期処理中の判断
          if (data.data == null) {
            // データ取得前はローディング中のプログレスを表示
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            // データ取得後はリストビューに情報をセット
            final apps = data.data as List<Application>;

            return _toggleView(apps);
          }
        },
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Home",
              onclick: () {
                print('home');
              }),
          TabData(
              iconData: Icons.search,
              title: "Search",
              onclick: () {
                print('Search');
              }),
          TabData(iconData: Icons.shopping_cart, title: "Basket")
        ],
        initialSelection: 1,
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
