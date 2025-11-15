import 'package:geolocator/geolocator.dart';
import 'package:office_tracker/utils/logging_util.dart';

class GeoPosition {
  final double latitude;
  final double longitude;

  GeoPosition({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'GeoPosition { latitude: $latitude, longitude: $longitude }';
  }
}

class LocationService {
  static final _log = LoggingUtil('NotificationService');

  Future<void> _initLocation() async {
    _log.debug('Calling _initLocation');
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      final errorMessage = 'Location services are disabled.';
      _log.debug(errorMessage);
      return Future.error(errorMessage);
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requestPermission = await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        final errorMessage = 'Location permissions are denied';
        _log.debug(errorMessage);
        return Future.error(errorMessage);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      final errorMessage = 'Location permissions are permanently denied,'
          ' we cannot request permissions.';
      _log.debug(errorMessage);
      return Future.error(errorMessage);
    }
  }

  Future<GeoPosition> getLocation() async {
    _log.debug('Calling getLocation');
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition();
    return GeoPosition(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// Singleton Configuration
  LocationService._privateConstructor();

  static LocationService? _instance;

  static Future<LocationService> get instance async {
    if (_instance == null) {
      LocationService._log.debug('Starting LocationService');
      _instance = LocationService._privateConstructor();
      await _instance?._initLocation();
    }
    return _instance!;
  }
}