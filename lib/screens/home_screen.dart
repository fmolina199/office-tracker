import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:office_tracker/screens/calendar_screen.dart';
import 'package:office_tracker/screens/report_screen.dart';
import 'package:office_tracker/screens/settings_screen.dart';
import 'package:office_tracker/services/location_service.dart';
import 'package:office_tracker/services/presence_history_service.dart';
import 'package:office_tracker/utils/logging_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final _log = LoggingUtil('_HomeScreenState');
  
  static final _titles = [
    'Calendar',
    'Reports',
    'Settings',
  ];

  void _onReceiveTaskData(Object data) {
    _log.info("Calling _onReceiveTaskData");
    if (data is Map<String, dynamic>) {
      var position = GeoPosition.fromJson(data);
      _log.debug("Received: $position");

      Future.delayed(Duration.zero, () async {
        _log.debug('Reloading presence history from file');
        final phService = await PresenceHistoryService.instance;
        await phService.reloadFromFile();
      });
    }
  }

  Future<void> _requestPermissions() async {
    _log.info("Calling _requestPermissions");
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

  void _initService() {
    _log.info("Calling _initService");
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
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

  var _selectedIndex = 0;
  final List<Widget> _widgets = <Widget>[
    CalendarScreen(),
    ReportScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      _log.info("Calling addTaskDataCallback");
      await _requestPermissions();
      _initService();
    });
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _log.debug('Calling build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_titles.elementAt(_selectedIndex)),
      ),
      body: Center(
        child: _widgets.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_input_component_rounded),
              label: 'Settings',
          ),
        ],
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      )
    );
  }
}