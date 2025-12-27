import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:native_geofence/native_geofence.dart';
import 'package:office_tracker/services/notification_service.dart';
import 'package:office_tracker/services/presence_history_service.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> geofenceTriggered(GeofenceCallbackParams params) async {
  final log = LoggingUtil('geofenceTriggered');
  log.debug('Received parameters: $params');

  log.debug('Sending notification check');
  final notificationService = await NotificationService.instance;
  await notificationService.sendNotification(
      "Checking your location",
      "Received param: ${params.event}");

  if (params.event == GeofenceEvent.enter
      || params.event == GeofenceEvent.dwell
  ) {
    // Save information
    log.debug('Setting presence');
    final phService = await PresenceHistoryService.instance;
    await phService.add(DateTime.now(), PresenceEnum.present);

    // Send notification to phone
    log.debug('Sending notification presence');
    await notificationService.sendNotification(
        "Welcome to your office",
        "You one day closer to your required attendance");

    // Send information back to application
    log.debug('Loading port');
    final SendPort? send = IsolateNameServer
        .lookupPortByName('native_geofence_send_port');
    if (send != null) {
      log.debug('Sending data through port');
      send.send('${DateTime.now()}');
    }
  }

  //TODO Wait?! Is this really necessary
  log.debug('Waiting...');
  await Future.delayed(const Duration(seconds: 1));
}

typedef GeofenceCallback = void Function(String message);
class GeofenceService {
  static final _log = LoggingUtil('GeofenceService');

  /// Class Implementation
  final _port = ReceivePort();

  Future<List<String>> getActiveGeofence() async {
    _log.info('Calling getActiveGeofence');
    return NativeGeofenceManager
        .instance.getRegisteredGeofenceIds();
  }

  Future<void> deleteGeofence() async {
    _log.info('Calling deleteGeofence');
    await NativeGeofenceManager.instance.removeAllGeofences();
  }

  Future<void> createGeofence({
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) async {
    _log.info('Calling createGeofence');
    await _checkPermissions();
    final location = Location(
        latitude: latitude,
        longitude: longitude
    );
    final geofence = Geofence(
      id: 'geofence',
      location: location,
      radiusMeters: radiusMeters,
      triggers: {
        GeofenceEvent.enter,
        GeofenceEvent.exit,
      },
      iosSettings: IosGeofenceSettings(
        initialTrigger: true,
      ),
      androidSettings: AndroidGeofenceSettings(
        initialTriggers: {
          GeofenceEvent.enter,
          GeofenceEvent.dwell,
          GeofenceEvent.exit
        },
        loiteringDelay: const Duration(minutes: 30),
        notificationResponsiveness: const Duration(minutes: 5),
      ),
    );
    await NativeGeofenceManager.instance
        .createGeofence(geofence, geofenceTriggered);
  }

  void setCallback(GeofenceCallback callback) {
    _log.debug('Calling setCallback');
    _port.listen((message) {
      _log.info("Received message from isolate: $message");
      callback("$message");
    });
  }

  Future<void> _init() async {
    _log.debug('Calling _init');
    await NativeGeofenceManager.instance.initialize();
    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'native_geofence_send_port',
    );
  }

  /// Singleton Configuration
  GeofenceService._privateConstructor();

  static GeofenceService? _instance;

  static Future<GeofenceService> get instance async {
    if (_instance == null) {
      GeofenceService._log.debug('Starting GeofenceService');
      _instance = GeofenceService._privateConstructor();
      await _instance?._init();
    }
    return _instance!;
  }

  static Future<void> _checkPermissions() async {
    _log.debug('Calling _checkPermissions');
    if (await Permission.locationAlways.isPermanentlyDenied) {
      return Future.error("Please manually update location permissions");
    }
    if (await Permission.location.isDenied) {
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
}