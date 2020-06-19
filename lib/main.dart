import 'package:app_manager/app_lists.dart';
import 'package:app_manager/search.dart';
import 'package:app_manager/settings.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int currentPage = 1;

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

  Widget _getPage(pageNum) {
    switch (pageNum) {
      case 0:
        return AppLists(viewType: _viewType);
      case 1:
        return Search();
      case 2:
        return Settings();
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
          TabData(iconData: Icons.settings, title: "Settings")
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
