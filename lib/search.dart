import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

import 'information.dart';
import 'model/app_info_model.dart';

class Search extends StatefulWidget {
  Search({Key key, this.getAppsFunction}) : super(key: key);

  final Future<List<AppInfoModel>> getAppsFunction;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<List<AppInfoModel>> search(String search) async {
    final apps = await widget.getAppsFunction;
    var searchApps = apps
        .where(
            (app) => app.name?.toLowerCase()?.contains(search?.toLowerCase()))
        .toList();
    return searchApps;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SearchBar<AppInfoModel>(
        onSearch: search,
        minimumChars: 1,
        onItemFound: (AppInfoModel app, int index) {
          final appIcon = app.icon;

          return ListTile(
            // `x is AnyClass` という記述は Java でいう `x instanceOf AnyClass`
            leading: appIcon != null
                // アイコンを持っているアプリ（ AppInfoModelWithIcon インスタンス）の場合はアイコンを表示する
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
                      builder: (context) => Information(appInfo: app)));
            },

            // リストタイトルにアプリ名＋パッケージ名を表示
            title: Text(app.name),

//            // リストサブタイトルにバージョンを表示
//            subtitle: Text(app.versionName),
          );
        },
      ),
    );
  }
}
