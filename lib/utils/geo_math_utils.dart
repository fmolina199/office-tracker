import 'dart:math';

import 'package:office_tracker/services/location_service.dart';

/// Copied from: https://github.com/jifalops/dart-latlong

/// Map related calculations class
class GeoMathUtils {
  static double earthRadius = 6378137;
  static double degreesToRadians(double deg) => deg * (pi / 180.0);


  /// Returns distance between two locations on earth
  static double distanceInMeters(
      GeoPosition p1,
      GeoPosition p2
  ) {
    // assuming earth is a perfect sphere(it's not)

    // Convert degrees to radians
    final lat1Rad = degreesToRadians(p1.latitude);
    final lon1Rad = degreesToRadians(p1.longitude);
    final lat2Rad = degreesToRadians(p2.latitude);
    final lon2Rad = degreesToRadians(p2.longitude);

    final sinDLat = sin((lat2Rad - lat1Rad) / 2);
    final sinDLng = sin((lon2Rad - lon1Rad) / 2);

    // Sides
    final a = pow(sinDLat, 2)
        + pow(sinDLng, 2)
          * cos(lat1Rad)
          * cos(lat2Rad);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}