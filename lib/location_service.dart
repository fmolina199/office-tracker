
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';

class LocationService {
  /// Class Implementation
  final _location = Location();
  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    _notificationPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
    );
    await _notificationPlugin.initialize(initializationSettings);
  }

  Future<void> initLocation() async {
    _location.onLocationChanged.listen((LocationData currentLocation) async {
      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails('notification_channel_id', 'My notification Channel',
          channelDescription: 'your channel description',
          importance: Importance.low,
          priority: Priority.low);
      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);
      await _notificationPlugin.show(0, 'plain title', 'plain body ${currentLocation.latitude}, ${currentLocation.longitude}', notificationDetails);
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
      await _instance?.initNotification();
      await _instance?.initLocation();
    }
    return _instance!;
  }
}