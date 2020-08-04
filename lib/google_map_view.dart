import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as l;

class GoogleMapView extends StatefulWidget {
  GoogleMapView({Key key, this.position}) : super(key: key);

  final LatLng position;

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapView> {
  Completer<GoogleMapController> _controller = Completer();
  l.Location _locationService = l.Location();

  // 現在位置
  l.LocationData _yourLocation;

  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

  // アプリの位置情報
  LatLng _position;

  final places = GoogleMapsPlaces(apiKey: "xxxxxxxxxxxxxxxxxx");

  @override
  void initState() {
    super.initState();

    // 現在位置の取得
    _getLocation();

    // 現在位置の変化を監視
    _locationChangedListen = _locationService.onLocationChanged
        .listen((l.LocationData result) async {
      setState(() {
        _yourLocation = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    // 監視を終了
    _locationChangedListen?.cancel();
  }

  Future<List<PlacesSearchResult>> search() async {
    PlacesSearchResponse response = await places.searchNearbyWithRadius(
        Location(_position.latitude, _position.longitude), 10);
    return response.results
        // 地名などをフィルタリング
        .where((element) => !element.types.contains('political'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // アプリの位置情報の登録がすでにあれば初期値としてセット
    if (_position == null) {
      _position = widget.position;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Google Map',
          style: GoogleFonts.mPLUS1p(
            textStyle: TextStyle(
              color: Colors.white,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _makeGoogleMap(),

      // タップしたアプリの位置情報を呼び出し元に返すためのボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectPosition(),
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
  }

  Widget _makeGoogleMap() {
    if (_yourLocation == null) {
      // 現在位置が取れるまではローディング中
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // マーカー（アプリの位置情報）を作成
      Set<Marker> markers = Set();
      if (_position != null) {
        markers.add(
            Marker(markerId: MarkerId('OnTapMarker'), position: _position));
      }

      // Google Map ウィジェットを返す
      return GoogleMap(
        // 初期表示される位置情報を現在位置から設定
        initialCameraPosition: CameraPosition(
          target: LatLng(_yourLocation.latitude, _yourLocation.longitude),
          zoom: 18.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },

        // 現在位置にアイコン（青い円形のやつ）を置く
        myLocationEnabled: true,

        // マーカー（アプリの位置情報）をセット
        markers: markers,

        // タップイベント
        onTap: (LatLng value) {
          setState(() {
            // タップイベントは位置情報を引数に持つので、それをアプリの位置情報に登録（画面再描画）
            _position = value;
            // 店舗情報を検索し、その結果をダイアログに表示・選択してもらう
            // →選択した位置情報を保存
            search().then((stores) {
              List<SimpleDialogOption> selectors = [
                // 選択肢の先頭に「店舗を選択しない」を用意
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text("店舗を選択しない"),
                ),
              ];
              stores.forEach((element) {
                // 取得した店舗情報をループし
                selectors.add(
                  SimpleDialogOption(
                    // 選択肢のプレスイベントに位置情報をセットする処理を設定
                    onPressed: () {
                      _position = LatLng(element.geometry.location.lat,
                          element.geometry.location.lng);
                      Navigator.pop(context);
                    },
                    // 店舗名を選択肢の名称に設定
                    child: Text(element.name),
                  ),
                );
              });
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text("店舗選択"),
                    children: selectors,
                  );
                },
              );
            });
          });
        },
      );
    }
  }

  /// マーカーの位置情報を引数に、呼び出し元画面へ遷移する
  void _selectPosition() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("アプリの位置情報"),
          content: Text("この位置でよろしいですか？"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pop(_position);
              },
            ),
          ],
        );
      },
    );
  }
}
