import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationUtils {
  static final Location _locationService = Location();

  static Future<LocationData> getLocation() async {
    return await _locationService.getLocation();
  }
}
