import 'package:location/location.dart';
import 'package:office_tracker/services/notification_service.dart';

class LocationService {
  /// Class Implementation
  final _location = Location();

  Future<void> initLocation() async {
    _location.onLocationChanged.listen((LocationData currentLocation) async {
      final notificationService = await NotificationService.instance;
      notificationService.sendNotification(
        "Office Tracker",
        "New office entry was registered",
      );
    });
  }

  Future<LocationData> getLocation() async {
    return _location.getLocation();
  }

  /// Singleton Configuration
  LocationService._privateConstructor();

  static LocationService? _instance;

  static Future<LocationService> get instance async {
    if (_instance == null) {
      _instance = LocationService._privateConstructor();
      await _instance?.initLocation();
    }
    return _instance!;
  }
}