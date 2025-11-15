import 'package:location/location.dart';
import 'package:office_tracker/services/notification_service.dart';
import 'package:office_tracker/utils/logging_util.dart';

class LocationService {
  static final _log = LoggingUtil('NotificationService');

  /// Class Implementation
  final _location = Location();

  Future<void> _initLocation() async {
    _log.debug('Calling _initLocation');
    _location.onLocationChanged.listen((LocationData currentLocation) async {
      final notificationService = await NotificationService.instance;
      notificationService.sendNotification(
        "Office Tracker",
        "New office entry was registered",
      );
    });
  }

  Future<LocationData> getLocation() async {
    _log.debug('Calling getLocation');
    return _location.getLocation();
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