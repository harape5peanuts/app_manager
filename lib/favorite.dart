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
              'お気に入りアプリがないよ(¯－¯٥)',
              style: GoogleFonts.mPLUS1p(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'アプリ情報の★をタップしてお気に入りのアプリを登録しよう！',
              style: GoogleFonts.mPLUS1p(textStyle: TextStyle(height: 1.3)),
            ),
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
                leading: appIcon != null
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(appIcon),
                        backgroundColor: Colors.white,
                      )
                    : null,

                // タップした場合は、詳細画面に遷移する
                onTap: () {
                  Navigator.push(
                    this.context,
                    MaterialPageRoute(
                      builder: (context) => Information(appInfo: app),
                    ),
                  );
                },

                // リストタイトルにアプリ名＋パッケージ名を表示
                title: Text("${app.name}"),

                // リストサブタイトルにバージョンを表示
                subtitle: Text('${app.memo}'),
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
