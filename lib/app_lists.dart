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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
          PopupMenuButton(
              icon: Icon(Icons.format_list_bulleted),
              itemBuilder: (BuildContext context) {
                print('button');
              },
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

            return GridView.builder(
              itemCount: apps.length,
              primary: false,
              padding: const EdgeInsets.all(40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 50,
                mainAxisSpacing: 40,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                final app = apps[index];
                return Container(
                  child: app is ApplicationWithIcon
                  // アイコンを持っているアプリ（ ApplicationWithIcon インスタンス）の場合はアイコンを表示する
                      ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (context) => AppInfo())
                          );
                        },
                        child: CircleAvatar(
                    backgroundImage: MemoryImage(app.icon as Uint8List),
                    backgroundColor: Colors.white,
                  ),
                      )
                  // ない場合はアイコンなし
                      : null,
                );
              },
            );
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