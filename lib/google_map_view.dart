import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapView extends StatefulWidget {
  GoogleMapView({Key key, this.position}) : super(key: key);

  final LatLng position;

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapView> {
  Completer<GoogleMapController> _controller = Completer();
  Location _locationService = Location();

  // 現在位置
  LocationData _yourLocation;

  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

  // アプリの位置情報
  LatLng _position;

  @override
  void initState() {
    super.initState();

    // 現在位置の取得
    _getLocation();

    // 現在位置の変化を監視
    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
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

  @override
  Widget build(BuildContext context) {
    // アプリの位置情報の登録がすでにあれば初期値としてセット
    if (_position == null) {
      _position = widget.position;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Google Map',
          style: GoogleFonts.kanit(
            textStyle: TextStyle(
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
      body: _makeGoogleMap(),

      // タップしたアプリの位置情報を呼び出し元に返すためのボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectPosition(),
        child: Icon(Icons.check),
      ),
    );
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
//            search();
          });
        },
      );
    }
  }

//  void search() async {
//    PlacesSearchResponse response = await places.searchNearbyWithRadius(
//        Location(_position.latitude, _position.longitude), 10);
//    print(response);
//  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
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

                // ここでアプリの位置情報を渡している
                Navigator.of(context).pop(_position);
              },
            ),
          ],
        );
      },
    );
  }
}
