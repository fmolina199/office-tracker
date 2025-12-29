import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/utils/platform_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class GeoPosition {
  late final DateTime dateTime;
  final double latitude;
  final double longitude;

  GeoPosition({
    required this.latitude,
    required this.longitude,
  }) {
    dateTime = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestampMillis': dateTime.millisecondsSinceEpoch,
    };
  }

  GeoPosition.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double,
        longitude = json['longitude'] as double,
        dateTime = DateTime.fromMillisecondsSinceEpoch(
            json['timestampMillis'] as int);

  @override
  String toString() {
    return 'GeoPosition { '
        'latitude: $latitude, '
        'longitude: $longitude '
        'dateTime: $dateTime '
        '}';
  }
}

class LocationService {
  static final _log = LoggingUtil('LocationService');

  static Future<void> _checkPermissionsMobile() async {
    _log.debug('Calling _checkPermissionsMobile');
    if (await Permission.location.isPermanentlyDenied
        || await Permission.locationAlways.isPermanentlyDenied
    ) {
      return Future.error("Please manually update location permissions");
    }

    if (PlatformUtils.isMobile && await Permission.location.isDenied) {
      final result = await Permission.location.request();
      if (result.isDenied) {
        return Future.error("Request for location was denied");
      }
    }

    if (await Permission.locationAlways.isDenied) {
      final result = await Permission.locationAlways.request();
      if (result.isDenied) {
        return Future.error("Request for locationAlways was denied");
      }
    }
  }

  static Future<void> _checkPermissionsDesktop() async {
    _log.debug('Calling _checkPermissionsDesktop');
    // Test if location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, '
              'we cannot request permissions.');
    }
  }

  static Future<void> _checkPermissions() async {
    _log.debug('Calling _checkPermissions');
    // If mobile check permissions for mobile (Android, IOS)
    if (PlatformUtils.isMobile) {
      await _checkPermissionsMobile();
      return;
    }

    // If not mobile check permissions for desktop (MacOS, Linux, Windows)
    await _checkPermissionsDesktop();
  }

  Future<void> _init() async {
    await _checkPermissions();
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
      await _instance?._init();
    }
    return _instance!;
  }
}