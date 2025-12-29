import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:office_tracker/services/location_service.dart';
import 'package:office_tracker/services/notification_service.dart';
import 'package:office_tracker/services/presence_history_service.dart';
import 'package:office_tracker/services/settings_service.dart';
import 'package:office_tracker/utils/geo_math_utils.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/utils/platform_utils.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';

class LocationHandler extends TaskHandler {
  static final _log = LoggingUtil('LocationHandler');
  
  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _log.info('onStart(starter: ${starter.name})');
  }

  static Future<void> process(DateTime timestamp) async {
    _log.debug('onRepeatEvent starting delayed task');

    try {
      // Get Current location
      final locationService = await LocationService.instance;
      final position = await locationService.getLocation();
      _log.debug('onRepeatEvent Location: $position');

      // Load settings
      final settingsService = await SettingsService.instance;
      final expectedPosition = settingsService.settings.position;
      final maxDistance = settingsService.settings.distanceMeters;

      // Calculate distance from expected position
      final distance = GeoMathUtils.distanceInMeters(
          position, expectedPosition);
      if (distance > maxDistance) {
        _log.info('onRepeatEvent Far far away from $maxDistance, skipping...');
        return;
      }

      // Save information
      _log.debug('onRepeatEvent Setting presence');
      final phService = await PresenceHistoryService.instance;
      await phService.reloadFromFile();
      if (phService.isPresent(timestamp)) {
        _log.info('onRepeatEvent Day already has a mark, skipping...');
        return;
      }

      // If day hasn't a mark, set it to present
      await phService.add(timestamp, PresenceEnum.present);

      if (PlatformUtils.isMobile) {
        //TODO check why notification is not working
        // Send notification to phone
        _log.debug('onRepeatEvent Sending notification presence');
        final notificationService = await NotificationService.instance;
        await notificationService.sendNotification(
            "Welcome to your office",
            "You one day closer to your required attendance");
      }
      FlutterForegroundTask.sendDataToMain(position.toJson());
    } catch (exp) {
      _log.error("Found exception: $exp");
    }
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {
    // Send data to main isolate.
    _log.info('onRepeatEvent($timestamp)');
    Future.delayed(Duration.zero, () async {
      process(timestamp);
    });
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _log.info('onDestroy(isTimeout: $isTimeout)');
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    _log.info('onReceiveData: $data');
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    _log.info('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    _log.info('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    _log.info('onNotificationDismissed');
  }
}