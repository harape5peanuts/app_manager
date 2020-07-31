import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'information.dart';
import 'model/app_info_model.dart';

class Favorite extends StatefulWidget {
  Favorite({Key key, this.viewType, this.getAppsFunction}) : super(key: key);

  final String viewType;
  final Future<List<AppInfoModel>> getAppsFunction;

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  Widget _textView() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'お気に入りしているアプリがありません',
              style: GoogleFonts.mPLUS1p(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Text('アプリ情報の★をタップしてお気に入りのアプリを登録しよう！'),
          ],
        ),
      ),
    );
  }

  Widget _toggleView(apps) {
    if (widget.viewType == 'grid') {
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
          final appIcon = app.icon;
          return Container(
            child: appIcon != null
                // アイコンを持っているアプリ（ AppInfoModelWithIcon インスタンス）の場合はアイコンを表示する
                ? GestureDetector(
                    // タップした場合は、詳細画面に遷移する
                    onTap: () {
                      Navigator.push(
                        this.context,
                        MaterialPageRoute(
                          builder: (context) => Information(appInfo: app),
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
          final appIcon = app.icon;

          // アプリひとつずつ横並び（ Column ）で情報を表示する
          return Column(
            children: <Widget>[
              ListTile(
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
                title: Text("${app.name}"),

                // リストサブタイトルにバージョンを表示
//                subtitle: Text('Version: ${app.versionName}'),
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
    return FutureBuilder(
      // `device_apps` パッケージを利用して端末にインストールされているアプリの一覧を取得している
      future: widget.getAppsFunction,
      builder: (context, data) {
        // 非同期処理中の判断
        if (data.data == null) {
          // データ取得前はローディング中のプログレスを表示
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else {
          // データ取得後はリストビューに情報をセット
          final apps = data.data as List<AppInfoModel>;

          if (apps == null || apps.isEmpty) {
            return _textView();
          } else {
            return _toggleView(apps);
          }
        }
      },
    );
  }
}
