import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _initNotification() async {
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

  NotificationDetails _createNotificationDetails({
    final String channelId = 'office_tracker_notification_channel',
    final String channelName = 'Office Tracker Notification Channel',
    final String channelDescription = 'Default Office Tracker Notification Channel'
  }) {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.low,
        priority: Priority.low);
    return NotificationDetails(android: androidDetails);
  }

  Future<void> sendNotification(
    final String title,
    final String message,
    {final String channelId = 'office_tracker_notification_channel'}
  ) async {
    await _notificationPlugin.show(
        0,
        title,
        message,
        _createNotificationDetails(channelId: channelId));
  }

  /// Singleton Configuration
  NotificationService._privateConstructor();

  static NotificationService? _instance;

  static Future<NotificationService> get instance async {
    if (_instance == null) {
      _instance = NotificationService._privateConstructor();
      await _instance?._initNotification();
    }
    return _instance!;
  }
}