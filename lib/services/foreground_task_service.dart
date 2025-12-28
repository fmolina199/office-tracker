import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:office_tracker/handlers/location_handler.dart';
import 'package:office_tracker/utils/logging_util.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationHandler());
}

class ForegroundTaskService {
  static final _log = LoggingUtil('ForegroundTaskService');

  static Future<void> _checkPermissions() async {
    _log.info("Calling _checkPermissions");
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }

  static void _initService() {
    _log.info("Calling _initService");
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'office_tracker_foreground_service',
        channelName: 'Office Tracker Foreground Service Notification',
        channelDescription:
        'This notification appears when the Office Tracker'
            ' foreground service is running.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1_200_000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> _init() async {
    await _checkPermissions();
    _initService();
  }

  Future<void> startService() async {
    // Start foreground service
    final ServiceRequestResult result = await FlutterForegroundTask
        .startService(
      serviceId: 200,
      notificationTitle: 'Office Tracker',
      notificationText: 'Starting GPS tracking',
      callback: startCallback,
    );

    // Return error in case it happens
    if (result is ServiceRequestFailure) {
      _log.error("ServiceRequestFailure when foreground task init");
      throw result.error;
    }
  }

  Future<void> stopService() async {
    await FlutterForegroundTask.stopService();
  }

  /// Singleton Configuration
  ForegroundTaskService._privateConstructor();

  static ForegroundTaskService? _instance;

  static Future<ForegroundTaskService> get instance async {
    if (_instance == null) {
      ForegroundTaskService._log.debug('Starting LocationService');
      _instance = ForegroundTaskService._privateConstructor();
      await _instance?._init();
    }
    return _instance!;
  }
}