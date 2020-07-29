import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationUtils {
  static final Location _locationService = Location();
  static Future<LocationData> getLocation() async {
//    final location = await _locationService.getLocation();
//    return LatLng(location.latitude, location.longitude);
      return await _locationService.getLocation();
  }
}