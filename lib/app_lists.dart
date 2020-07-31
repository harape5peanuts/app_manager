import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'information.dart';
import 'model/app_info_model.dart';

class AppLists extends StatefulWidget {
  AppLists(
      {Key key, this.viewType, this.getAppsFunction, this.getAllAppsFunction})
      : super(key: key);

  final String viewType;
  final Future<List<AppInfoModel>> getAppsFunction;
  final Future<List<AppInfoModel>> getAllAppsFunction;

  @override
  _AppListsState createState() => _AppListsState();
}

class _AppListsState extends State<AppLists> {
  List<AppInfoModel> _apps;
  List<AppInfoModel> _allApps;

  Widget _toggleView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Text(
              '近くに登録されたアプリ',
              style: GoogleFonts.mPLUS1p(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        _apps.isEmpty
            ? SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    '近くで登録されたアプリはないみたい(¯－¯٥)',
                    style: GoogleFonts.mPLUS1p(),
                  ),
                ),
              )
            : SliverToBoxAdapter(),
        (widget.viewType == 'grid') ? _makeGrid(_apps) : _makeLists(_apps),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Text(
              'すべてのアプリ',
              style: GoogleFonts.mPLUS1p(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        (widget.viewType == 'grid')
            ? _makeGrid(_allApps)
            : _makeLists(_allApps),
      ],
    );
  }

  Widget _makeGrid(List<AppInfoModel> apps) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          crossAxisCount: 3,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final app = apps[index];
            final appIcon = app.icon;
            return GestureDetector(
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
            );
          },
          childCount: apps.length,
        ),
      ),
    );
  }

  Widget _makeLists(List<AppInfoModel> apps) {
    List<Column> lists = [];
    apps.forEach((app) {
      final appIcon = app.icon;
      lists.add(
        Column(
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
                subtitle: Text('${app.memo}'),
            ),

            // アンダーライン
            Divider(
              height: 1.0,
            )
          ],
        ),
      );
    });

    return SliverList(
        delegate: new SliverChildListDelegate(
      lists,
    ));
  }

  Future<List<AppInfoModel>> _getApps() async {
    _apps = await widget.getAppsFunction;
    _allApps = await widget.getAllAppsFunction;
    return _apps;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // `device_apps` パッケージを利用して端末にインストールされているアプリの一覧を取得している
      future: _getApps(),
      builder: (context, data) {
        // 非同期処理中の判断
        if (data.data == null) {
          // データ取得前はローディング中のプログレスを表示
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else {
          // データ取得後はリストビューに情報をセット
//          final apps = data.data as List<AppInfoModel>;

          return _toggleView();
        }
      },
    );
  }
}
