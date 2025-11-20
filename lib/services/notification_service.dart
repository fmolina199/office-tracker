import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:office_tracker/utils/logging_util.dart';

class NotificationService {
  static final _log = LoggingUtil('NotificationService');

  /// Class Implementation
  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  void _checkPermissions() {
    _log.debug('Calling _checkPermissions');
    if (Platform.isAndroid) {
      _notificationPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      _notificationPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    } else if (Platform.isMacOS) {
      _notificationPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    }
  }

  InitializationSettings _createNotificationSettings() {
    _log.debug('Calling _createNotificationSettings');
    const AndroidInitializationSettings initializationSettingsAndroid
        = AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin
        = DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );
    final LinuxInitializationSettings initializationSettingsLinux
        = LinuxInitializationSettings(defaultActionName: 'Open notification');
    final WindowsInitializationSettings initializationSettingsWindows
        = WindowsInitializationSettings(
          appName: 'Office Tracker',
          appUserModelId: 'com.workday.office_tracker',
          guid: 'd001b40d-3f24-48c2-84e0-c834808ec426'
        );
    return InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux,
        windows: initializationSettingsWindows,
    );
  }

  Future<void> _init() async {
    _log.debug('Calling _init');
    _checkPermissions();
    await _notificationPlugin.initialize(_createNotificationSettings());
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
      NotificationService._log.debug('Starting NotificationService');
      _instance = NotificationService._privateConstructor();
      await _instance?._init();
    }
    return _instance!;
  }
}