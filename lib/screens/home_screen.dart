import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/screens/calendar_screen.dart';
import 'package:office_tracker/screens/report_screen.dart';
import 'package:office_tracker/screens/settings_screen.dart';
import 'package:office_tracker/services/foreground_task_service.dart';
import 'package:office_tracker/services/location_service.dart';
import 'package:office_tracker/services/presence_history_service.dart';
import 'package:office_tracker/state_management/settings_cubit.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/utils/platform_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Static Properties
  static final _log = LoggingUtil('_HomeScreenState');
  static final _titles = [
    'Calendar',
    'Reports',
    'Settings',
  ];

  // Properties
  var _selectedIndex = 0;
  final List<Widget> _widgets = <Widget>[
    CalendarScreen(),
    ReportScreen(),
    SettingsScreen(),
  ];

  // Called when foreground service update location
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

  Future<void> _startForegroundService() async {
    if (!context.mounted) {
      _log.warn("_startForegroundService: context not mounted");
      return;
    }

    final settings = context.read<SettingsCubit>().state;
    if (!settings.foregroundTaskEnabled) {
      _log.warn("_startForegroundService: foreground task disabled");
      return;
    }

    if (PlatformUtils.isMobile) {
      _log.warn("_startForegroundService: starting mobile foreground service");
      final foregroundService = await ForegroundTaskService.instance;
      await foregroundService.startService();
    } else {
      _log.warn("_startForegroundService: starting isolate foreground service");
      final rootIsolateToken = RootIsolateToken.instance!;
      Isolate.spawn(isolateMain, rootIsolateToken);
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    // Read settings to init cubit, the settings will take 0.5s to be loaded
    // After it's loaded we can call _startForegroundService
    context.read<SettingsCubit>().state;
    Future.delayed(oneSecondDuration, _startForegroundService);
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